import { Provider } from 'preact-redux';
import store from './store';
import App from './components/app';
import * as cs  from 'd3-scale-chromatic';
import './style';
export default () => (
	<div id="outer">
		<Provider store={store}>
			<App />
		</Provider>
	</div>
);
