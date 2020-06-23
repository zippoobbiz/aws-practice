import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import registerServiceWorker from './registerServiceWorker';
import axios from 'axios';


// const env = dotenv.config().parsed;
console.log("backend_url: " + process.env.BACKEND_URL);
axios.defaults.baseURL =  process.env.BACKEND_URL// the prefix of the URL
axios.defaults.headers.get['Accept'] = 'application/json'   // default header for all get request
axios.defaults.headers.post['Accept'] = 'application/json'  // default header for all POST request

ReactDOM.render(<App />, document.getElementById('root'));
registerServiceWorker();
