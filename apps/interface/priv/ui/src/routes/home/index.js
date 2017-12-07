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

	render = ({ ...state }, { text }) => {
		return (
      <div className="homepage" >
        <LayoutGrid>
          <LayoutGrid.Inner>
            <DeviceGroup title="HVAC" devices={state.hvac} name="hvac" graph_var={["temperature", "temporary_target_cool", "temporary_target_heat"]} color={this.hues[4]} />
            <DeviceGroup title="Weather" devices={state.weather_station} name="weather_station" graph_var={["outdoor_temperature", "indoor_temperature"]} color={this.hues[0]} />
            <DeviceGroup title="Energy" devices={state.energy} name="energy" graph_var={["kw"]} color={this.hues[2]} />
            <DeviceGroup title="IEQ" devices={state.ieq} name="ieq" graph_var={["co2", "voc", "pm"]} color={this.hues[1]} />
          </LayoutGrid.Inner>
        </LayoutGrid>
      </div>
    );
	};
}
