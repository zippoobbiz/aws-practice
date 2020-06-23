import React from 'react';
import './newsList.css';
import News from '../news/news';

class NewsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: props.data
    };
  }

  render() {
    return (
      <div className="main">
        {
          this.props.data.map((item, index) => {
            return(
                <News key={index}
                      title={item.title}
                      id={item.id}
                      callBack={this.props.callBack}
              />
            )
          })
        }
      </div>
    );
  }
}

export default NewsList
