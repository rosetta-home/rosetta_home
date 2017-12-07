import { h, Component } from 'preact';
import Toolbar from 'preact-material-components/Toolbar';
import 'preact-material-components/Toolbar/style.css';
import {interpolateGreys} from 'd3-scale-chromatic';
// import style from './style';

export default class Header extends Component {

	render() {
		return (
			<div>
				<Toolbar className="toolbar" fixed={true} style={{"background-color": interpolateGreys(.7)}} >
					<Toolbar.Row>
						<Toolbar.Section align-start>
							<Toolbar.Title>Rosetta Home</Toolbar.Title>
						</Toolbar.Section>
					</Toolbar.Row>
				</Toolbar>
			</div>
		);
	}
}
