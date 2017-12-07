import { h, Component } from 'preact';
import Card from 'preact-material-components/Card';
import 'preact-material-components/Card/style.css';
import List from 'preact-material-components/List';
import 'preact-material-components/List/style.css';
import RealtimeGraph from './realtime-graph'

export default class Sensor extends Component {

  render = ({ title, list, name, graph_var, color}) => {
    var value = list.length ? list[list.length-1].data_point : 0;
    var out = [];
    var title_text = "";
    title_text = title + " | " + value.interface_pid;
    for(var k in value.state){
      if(graph_var.indexOf(k) != -1){
        var tag = k.split("_").map((word) => word.charAt().toUpperCase() + word.substr(1))
        out.push(
          <List.Item>
            <List.PrimaryText>{tag.join(" ")}: &nbsp;</List.PrimaryText>
            <List.SecondaryText>{value.state[k]}</List.SecondaryText>
          </List.Item>
        );
      }
    }
    return (
      <Card style={{"background-color": color(.2)}}>
        <Card.Primary style={{"background-color": color(.5)}}>
          <Card.Title style={{"color": color(0)}}>
            {title_text}
          </Card.Title>
        </Card.Primary>
        <Card.Media className='card-media' style={{"padding": "0px", "padding-top": "10px"}}>
          <div id={value.interface_pid}>
            <RealtimeGraph list={list} type={name} name={value.interface_pid} color={color} graph_var={graph_var} />
          </div>
        </Card.Media>
        <Card.HorizontalBlock style={{"background-color": color(.1)}}>
          <Card.Primary style={{"color": color(1)}}>
            <List className={"mdc-list--dense"}>
              {out.map((span) => span)}
            </List>
          </Card.Primary>
        </Card.HorizontalBlock>
      </Card>
    );
  }
}
