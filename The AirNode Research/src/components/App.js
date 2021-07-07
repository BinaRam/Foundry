import React, { Component } from 'react';
import logo from '../logo.png';
import logo2 from '../logo2.png';
import './App.css';

const ipfsClient = require('ipfs-http-client')
const ipfs = ipfsClient({ host: 'ipfs.infura.io', port: 5001, protocol:'https'})

class App extends Component {

  constructor(props){

    super(props);
    this.state = {
      buffer: null
    };
  }

  captureFile = (event) =>{
      event.preventDefault()
      console.log("File Captured")
      //Process file for IPFS
      const file = event.target.files[0]
      const reader = new window.FileReader()
      reader.readAsArrayBuffer(file)
      reader.onloadend = () =>{
        this.setState({'buffer':Buffer(reader.result) })
      }
  }
  
  onSubmit = (event) =>{
      event.preventDefault()
      ipfs.add(this.state.buffer,(error,result)=>{
        console.log(result)

        if(error){
          console.error(error)
        }
      })
  }

  render() {
    return (
      <div>

        <div className="container-fluid mt-5">
          <div className="row">
            <main role="main" className="col-lg-12 d-flex text-center">
              <div className="content mr-auto ml-auto">
                <a
                  href="https://docs.api3.org/pre-alpha/tutorials/airnode-starter.html"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <img src={logo} className="Airnode-logo" alt="logo" />
                <a
                  href="https://cloud.google.com/vision"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <img src={logo2} className="Cloud-Vision-logo" alt="logo2" />
                </a>
                </a>
                <h1>Airnode-Cloud-Vision-Integration</h1>
                <p>
                  Upload image below to get your ipfs hash and image attributes returned by Google Cloud Vision 
                </p>
                <p>&nbsp;</p>
                <form onSubmit={this.onSubmit}>
                  <input type='file' onChange={this.captureFile}/>
                  <input type='submit'/>
                </form>
                <p>&nbsp;</p>
                <h1>Still under Construction</h1>
              </div>
            </main>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
