import { h, Component } from 'preact';
import { Router } from 'preact-router';
import Header from './header';
import Home from '../routes/home';
import Profile from '../routes/profile';
import { updateData } from '../actions';
import store from '../store';

export default class App extends Component {
	/** Gets fired when the route changes.
	 *	@param {Object} event		"change" event from [preact-router](http://git.io/preact-router)
	 *	@param {string} event.url	The newly routed URL
	 */
	handleRoute = e => {
		this.currentUrl = e.url;
	};

	componentDidMount = () => {
		this.interval = setInterval(() => {
			store.dispatch(updateData());
		}, 500);
	};

	componentWillUnmount = () => {
		clearInterval(this.interval);
	}

	render = () => {
		return (
			<div id="app">
				<Header />
				<Home />
			</div>
		);
	}
}
