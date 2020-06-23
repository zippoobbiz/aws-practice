import React from 'react';
import axios from 'axios';
import './news.css'

class News extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      isIdShown: false,
      isUpdating: false,
      title: props.title
    };
    // This binding is necessary to make `this` work in the callback
    this.handleView = this.handleView.bind(this);
    this.handleDelete = this.handleDelete.bind(this);
    this.handleUpdateShown = this.handleUpdateShown.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.handleUpdate = this.handleUpdate.bind(this);
  }

  handleChange(event) {
    this.setState({title: event.target.value});
  }

  handleView() {
    this.setState(state => ({
      isIdShown: !state.isIdShown
    }));
  }

  handleUpdateShown() {
    this.setState(state => ({
      isUpdating: !state.isUpdating
    }));
  }

  handleUpdate() {
    axios.post('http://localhost:8081/update', {
      id: this.props.id,
      title: this.state.title
    }).then(res => {
      this.setState(state => ({
        isUpdating: !state.isUpdating
      }));
      this.props.callBack();
    }).catch((err) => {
      console.log('I\'m sorry, Error......')
    });


  }

  handleDelete() {
    axios.post('http://localhost:8081/delete', {
      id: this.props.id
    }).then(res => {
      this.props.callBack();
    }).catch((err) => {
      console.log('I\'m sorry, Error......')
    });
  }

  render() {
    return (
      <div className="news">
        {!this.state.isUpdating && 
          <div>
            <p className="news_title"> {this.props.title} </p>
            <button onClick={this.handleUpdateShown}>
              Update
            </button>
          </div>}
        {this.state.isUpdating && 
          <div>
            <input type="text" value={this.state.title} onChange={this.handleChange}/>
            <button onClick={this.handleUpdate}>
              Confirm
            </button>
            <button onClick={this.handleUpdateShown}>
              Cancel
            </button>
          </div>}
        <button onClick={this.handleView}>
          View
        </button>
        
        <button onClick={this.handleDelete}>
          Delete
        </button>
        {this.state.isIdShown && <p className="id"> {this.props.id} </p>}
      </div>
    );
  }
}

export default News
