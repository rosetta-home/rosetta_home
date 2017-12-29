import { h, Component } from 'preact';
import LayoutGrid from 'preact-material-components/LayoutGrid';
import 'preact-material-components/LayoutGrid/style.css';
import Sensor from './sensor';
import * as actions from '../actions';
import reduce from '../reducers';
import { connect } from 'preact-redux';

export default class DeviceGroup extends Component {

  sensor_card = (title, list, name, graph_var, color) => {
    return (
      <LayoutGrid.Cell cols="12" desktopCols="12" tabletCols="8" phoneCols="4">
        <Sensor list={list} title={title} name={name} color={color} graph_var={graph_var} />
      </LayoutGrid.Cell>
    )
  };

	render = ({title, devices, name, graph_var, color}) => {
    var out = [];
    for(var i in devices){
      out.push(this.sensor_card(title, devices[i], name, graph_var, color))
    }
    return (
      <LayoutGrid.Cell cols="4" desktopCols="4" tabletCols="4" phoneCols="4">
        <LayoutGrid.Inner>
          { out.map((h) => h) }
        </LayoutGrid.Inner>
      </LayoutGrid.Cell>
    )
	};
}
