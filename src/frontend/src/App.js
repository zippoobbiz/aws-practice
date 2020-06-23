import React, { Component } from 'react';
import NewsList from './components/newsList/newsList';
import axios from 'axios';
import CreateNews from './components/createNews/CreateNews';

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      data: []
    }

    this.refresh = this.refresh.bind(this);
  }

  refresh() {
    axios.get(
      'http://localhost:8081/select'
    ).then(res => {
      this.setState({
        data: res.data
      })
    }).catch((err) => {
      console.log('I\'m sorry, Error......')
    })
  }

  componentDidMount() {
    axios.get(
      'http://localhost:8081/select'
    ).then(res => {
      console.log('somehitng')
      console.log(res.data)
      this.setState({
        data: res.data
      })
    }).catch((err) => {
      console.log('I\'m sorry, Error......')
    })
  }

  render() {
    return (
      <div>
        <CreateNews callBack={this.refresh}/>
        <NewsList  data={this.state.data} callBack={this.refresh}/>
      </div>
    );
  }
}

export default App;
