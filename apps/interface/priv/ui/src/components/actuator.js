import { h, Component } from 'preact';
import Card from 'preact-material-components/Card';
import 'preact-material-components/Card/style.css';
import Switch from 'preact-material-components/Switch';
import 'preact-material-components/Switch/style.css';
import { sendAction } from '../actions';
import store from '../store';


export default class Actuator extends Component {

  switch = () => {
    var effect = this.props.value == 0 ? 1 : 0;
    store.dispatch(sendAction(this.props.name, effect));
  }

  render = ({ value, title, name, color }) => {
    var checked = value == "0" ? false : true;
    return (
      <div style={{"padding": "25px"}}>
        <Switch id={name+"-switch"} checked={checked} onClick={this.switch}/>
        <label style={{"padding": "10px"}} for={name+"-switch"}>{title}</label>
      </div>
    );
  }
}
