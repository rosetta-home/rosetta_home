import { h, Component } from 'preact';
import List from 'preact-material-components/List';
import 'preact-material-components/List/style.css';
import Button from 'preact-material-components/Button';
import 'preact-material-components/Button/style.css';

export default class TodoItem extends Component {
	remove = () => {
		let { onRemove, todo } = this.props;
		onRemove(todo);
	};

	shouldComponentUpdate({ todo, onRemove }) {
		return todo !== this.props.todo || onRemove !== this.props.onRemove;
	}

	render = ({ todo }) => {
		return (
			<List.Item>
				<List.LinkItem align-start>
					<Button onClick={this.remove}>×</Button>
				</List.LinkItem>
				<List.PrimaryText>{ ' ' + todo.text }</List.PrimaryText>
			</List.Item>
		);
	}
}
