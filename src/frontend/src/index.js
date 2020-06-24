import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import registerServiceWorker from './registerServiceWorker';
import axios from 'axios';

axios.defaults.baseURL =  "http://"+process.env.REACT_APP_BACKEND_URL// the prefix of the URL
axios.defaults.headers.get['Accept'] = 'application/json'   // default header for all get request
axios.defaults.headers.post['Accept'] = 'application/json'  // default header for all POST request

ReactDOM.render(<App />, document.getElementById('root'));
registerServiceWorker();
