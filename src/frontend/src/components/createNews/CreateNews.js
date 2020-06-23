import React from 'react';
import axios from 'axios';

class CreateNews extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    axios.post('http://localhost:8081/create', {
      title: this.state.value
    }).then(res => {
      this.props.callBack();
    }).catch((err) => {
      console.log('I\'m sorry, Error......')
    });
    
    // event.preventDefault();
  }

  render() {
    console.log(this.props)
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Title:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>
        <input type="submit" value="Create" />
      </form>
    );
  }
}

export default CreateNews;