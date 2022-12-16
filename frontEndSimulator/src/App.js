import { useState } from "react";
import axios from "axios";
import "./styling/index.css";
function App() {
  // State variables
  const [fileName, setFileName] = useState("");
  const [userDirName, setUserDirName] = useState("");
  const [projDirName, setProjDirName] = useState("");
  const [resp, setResp] = useState("");
  const [uid, setUID] = useState("");
  const [pid, setPID] = useState("");
  const [checkFileText, setCheckFileText] = useState("");

  //Get request handler
  function sendGet(endpoint) {
    const url = `http://localhost:4567/${endpoint}`;
    axios.get(url).then((response) => {
      console.log(response.data);
      setResp(JSON.stringify(response.data));
    });
  }

  //Post request handler
  function sendPost(endpoint, body) {
    const url = `http://localhost:4567/${endpoint}`;
    axios.post(url, body).then((response) => {
      console.log(response.data);
      setResp(JSON.stringify(response.data));
    });
  }

  return (
    <div className="App">
      <div className="c">
        <h1> Front-end </h1>
        <h3> User ID set to {uid} </h3>
        <h3> Project Name set to {pid} </h3>
      </div>
      <div className="c">
        <div className="buttonRow">
          {/* Creating a user directory */}
          <div className="buttonContainer">
            <input
              type="text"
              placeholder="user id"
              value={userDirName}
              onInput={(e) => setUserDirName(e.target.value)}
            ></input>
            <button
              className="button"
              onClick={() => {
                sendGet(`init/${userDirName}`);
                setUID(userDirName);
                setUserDirName("");
              }}
            >
              Create user directory
            </button>
          </div>

          {/* Creating a project directory */}
          <div className="buttonContainer">
            <input
              type="text"
              placeholder="project name"
              value={projDirName}
              onInput={(e) => setProjDirName(e.target.value)}
            ></input>
            <button
              className="button"
              onClick={() => {
                sendGet(`init/${uid}/${projDirName}`);
                setPID(projDirName);
                setProjDirName("");
              }}
            >
              Create project directory
            </button>
          </div>

          {/*Submiting a file */}
          <div className="buttonContainer">
            <input
              type="text"
              placeholder="file name"
              value={fileName}
              onInput={(e) => setFileName(e.target.value)}
            ></input>
            <button
              className="button"
              onClick={() => {
                const body = `{
                "fileName" : "${fileName}",
                "fileContents": "File contents here."
              }`;
                sendPost(`/${uid}/${pid}`, body);
                setFileName("");
              }}
            >
              Submit a file
            </button>
          </div>

          {/*Checking if a file was submitted*/}
          <div className="buttonContainer">
            <input
              type="text"
              placeholder="file name"
              value={checkFileText}
              onInput={(e) => setCheckFileText(e.target.value)}
            ></input>
            <button
              className="button"
              onClick={() => {
                console.log(`diff/${uid}/${pid}/${checkFileText}`);
                sendGet(`diff/${uid}/${pid}/${checkFileText}`);
                setCheckFileText("");
              }}
            >
              Diff file
            </button>
          </div>

          {/*Checking status of required files `checkUploadStatus */}
          <div className="buttonContainer">
            <br />
            <button
              className="button"
              onClick={() => {
                console.log(`checkUploadStatus/${uid}/${pid}`);
                sendGet(`checkUploadStatus/${uid}/${pid}`);
              }}
            >
              Check upload status
            </button>
          </div>
        </div>
        {/* Responses from the server  */}
        <div className="respContainer">
          <strong>Response</strong>
          <div className="breaker"></div>
          <p>{resp}</p>
        </div>
      </div>
    </div>
  );
}

export default App;
