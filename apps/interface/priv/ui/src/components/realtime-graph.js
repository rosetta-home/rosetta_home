import { h, Component } from 'preact';
import * as d3 from 'd3';
import { connect } from 'preact-redux';
import * as actions from '../actions';
import reduce from '../reducers';
import { num_data_points } from '../common/config'

@connect(reduce, actions)
export default class RealtimeGraph extends Component {

  shouldComponentUpdate = ({...state}) => {
    var list = state[this.props.type][this.props.name];
    this.x.domain([new Date(list[0].timestamp), new Date(list[list.length-1].timestamp)]);
    var max_v = 0;
    var min_v = 99999;
    for(var line in this.groups){
      var group = this.groups[line];
      var maxv = d3.max(list, (d) => (d.data_point.state[line]));
      max_v = Math.max(max_v, maxv);
      var minv = d3.min(list, (d) => (d.data_point.state[line]));
      min_v = Math.min(min_v, minv);
      var data = [];
      for(var d = 0; d < list.length; d++ ){
        data.push({value: list[d].data_point.state[line], timestamp: list[d].timestamp});
      }
      group.path.data([data]).attr('d', this.line);
    }
    this.y.domain([min_v/2, max_v]);
    this.axis.call(this.x_axis);
    this.axis.selectAll(".tick text")
      .attr("fill", this.props.color(.5))
      this.axis.selectAll(".tick line")
        .attr("stroke", this.props.color(.5))
    return false;
  }

  componentDidMount = ({...state}) => {
    this.groups = {}
    for(var line = 0; line < this.props.graph_var.length; line++){
      var attr = this.props.graph_var[line];
      this.groups[attr] = {
        value: 0,
        color: this.props.color(.3*line),
        attr: attr,
        data: this.props.list
      }
    }
    this.width = document.getElementById(this.props.name).clientWidth;
    var limit = 60 * 1,
      duration = 750,
      now = new Date(Date.now() - duration)
    var width = this.width;
    var height = 50;

    this.x = d3.scaleTime()
      .domain([new Date(2017, 11, 7), new Date()])
      .range([0, width]);

    this.y = d3.scaleLinear()
      .domain([0, 100])
      .range([height, 0])

    this.line = d3.line()
      .x((d) => this.x(new Date(d.timestamp)))
      .y((d) => this.y(d.value))

    var svg = d3.select('#'+this.props.name+'-svg')
      .attr('class', 'chart')
      .attr('width', width)
      .attr('height', height + 35)

    this.x_axis = d3.axisBottom(this.x)
      .ticks(5);

    this.axis = svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')')
      .call(this.x_axis);

    var paths = svg.append('g');

    for (var name in this.groups) {
      var group = this.groups[name];
      group.path = paths.append('path')
        .attr('class', name + ' group')
        .style('stroke', group.color)
        .style('fill', 'none')
    }
  };

  render = ({list, type, name, color, graph_var}) => {
    return (
      <svg id={name+"-svg"}></svg>
    );
  }
}
