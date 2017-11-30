import { h, Component } from 'preact';
import Card from 'preact-material-components/Card';
import 'preact-material-components/Card/style.css';
import TextField from 'preact-material-components/TextField';
import 'preact-material-components/TextField/style.css';
import 'preact-material-components/Button/style.css';
import List from 'preact-material-components/List';
import 'preact-material-components/List/style.css';
import TodoItem from '../../components/todo-item';
import reduce from '../../reducers';
import * as actions from '../../actions';
import { connect } from 'preact-redux';
import style from './style';

@connect(reduce, actions)
export default class Home extends Component {

  addTodos = () => {
    console.log(this.state.text);
		this.props.addTodo(this.state.text);
		this.setState({ text: '' });
	};

	removeTodo = (todo) => {
		this.props.removeTodo(todo);
	};

	updateText = (e) => {
		this.setState({ text: e.target.value });
	};

	render = ({ todos }, { text }) => {
		return (
      <Card>
        <Card.Primary>
          <form onSubmit={this.addTodos} action="javascript:">
            <TextField value={text} onInput={this.updateText} label="New ToDo..." />
          </form>
        </Card.Primary>
        <Card.HorizontalBlock>
          <Card.Primary>
            <List>
              { todos.map(todo => (
                <TodoItem key={todo.id} todo={todo} onRemove={this.removeTodo} />
              )) }
            </List>
          </Card.Primary>
        </Card.HorizontalBlock>
  		</Card>
    );
	};
}
