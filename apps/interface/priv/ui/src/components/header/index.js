import { h, Component } from 'preact';
import { route } from 'preact-router';
import Toolbar from 'preact-material-components/Toolbar';
import Drawer from 'preact-material-components/Drawer';
import List from 'preact-material-components/List';
import Dialog from 'preact-material-components/Dialog';
import Switch from 'preact-material-components/Switch';
import 'preact-material-components/Switch/style.css';
import 'preact-material-components/Dialog/style.css';
import 'preact-material-components/Drawer/style.css';
import 'preact-material-components/List/style.css';
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
