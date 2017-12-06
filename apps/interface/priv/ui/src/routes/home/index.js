import { h, Component } from 'preact';
import LayoutGrid from 'preact-material-components/LayoutGrid';
import 'preact-material-components/LayoutGrid/style.css';
import DeviceGroup from '../../components/device_group';
import reduce from '../../reducers';
import * as actions from '../../actions';
import { connect } from 'preact-redux';
import * as cs  from 'd3-scale-chromatic';
import style from './style';

@connect(reduce, actions)
export default class Home extends Component {
  constructor() {
    super();
    this.hues = [
      cs.interpolatePuBu,
      cs.interpolateBuPu,
      cs.interpolateReds,
      cs.interpolateGnBu,
      cs.interpolateBuGn,
      cs.interpolateOrRd,
      cs.interpolatePuRd,
      cs.interpolateGreys,
      cs.interpolateRdPu,
      cs.interpolatePuBuGn,
    ];
  }

  sensor_card = (title, list, name, graph_var, color) => {
    return (
      <LayoutGrid.Cell cols="3" desktopCols="3" tabletCols="4" phoneCols="4">
        <Sensor list={list} title={title} name={name} color={color} graph_var={graph_var} />
      </LayoutGrid.Cell>
    )
  };

	render = ({ ...state }, { text }) => {
		return (
      <div className="homepage" >
        <LayoutGrid>
          <LayoutGrid.Inner>
            <DeviceGroup title="HVAC" devices={state.hvac} name="hvac" graph_var="temperature" color={this.hues[4]} />
            <DeviceGroup title="Memory" devices={state.memory} name="memory" graph_var="allocated" color={this.hues[0]} />
            <DeviceGroup title="CPU" devices={state.cpu} name="cpu" graph_var="busy" color={this.hues[1]} />
          </LayoutGrid.Inner>
        </LayoutGrid>
      </div>
    );
	};
}
