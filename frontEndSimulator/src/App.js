import { useState } from "react";
import axios from "axios";
import { Box, Button, TextField } from "@mui/material";
import "./styling/index.css";
function App() {
  // State variables
  const [fileName, setFileName] = useState("");
  const [response, setResponse] = useState("");
  const [uid, setUID] = useState("");
  const [pid, setPID] = useState("");
  const [fileContents, setFileContents] = useState("");
  const [diff, setDiff] = useState("The `git diff` of a file with itself will appear here.")

  //Get request handler
  function sendGet(endpoint) {
    const url = `http://localhost:4567/${endpoint}`;
    axios.get(url).then((response) => {
      console.log(response.data);
      setResponse(JSON.stringify(response.data));
    });
  }

  //Post request handler
  function sendPost(endpoint, body) {
    const url = `http://localhost:4567/${endpoint}`;
    axios.post(url, body).then((response) => {
      console.log(response.data);
      setResponse(JSON.stringify(response.data));
    });
  }

  function getDiff(endpoint) {
    const url = `http://localhost:4567/${endpoint}`;
    axios.get(url).then((response) => {
      setResponse(JSON.stringify(response.data));
      setDiff(response.data['Message'].match(/(^-\w+.*)|(^\+\w+.*)|(^ \w+.*)/gm).join("\n"));
    });
  }

  const handleUidChange = (event) => {
    setUID(event.target.value);
  };

  const handlePidChange = (event) => {
    setPID(event.target.value);
  };

  const handleFileNameChange = (event) => {
    setFileName(event.target.value);
  };

  const handleFileContentsChange = (event) => {
    setFileContents(event.target.value);
  };

  return (
    <Box
      display="flex"
      flexDirection="column"
      alignItems="center"
    >
      <Box
        display="flex"
        flexDirection="column"
        alignItems="center"
        sx={{
          lineHeight: 0
        }}
      >
        <Box
          sx={{
            lineHeight: 1
          }}
        >
          <h1>Front-end</h1>
        </Box>
        
        <Box>
          <p>User ID is set to: {uid}</p>
        </Box>
        
        <Box>
          <p>Project Name is set to: {pid} </p>
        </Box>
        
        <Box>
          <p>File Name is set to: {fileName} </p>
        </Box>
      </Box>

      <Box
        display="flex"
      >
        <Box p={3}>
          <TextField
            label="User ID"
            onChange={handleUidChange}
          />
        </Box>

        <Box p={3}>
          <TextField
            label="Project Name"
            onChange={handlePidChange}
          />
        </Box>

        <Box p={3}>
          <TextField
            label="File Name"
            onChange={handleFileNameChange}
          />
        </Box>
      </Box>

      <Box
        display="flex"
      >
      <Box
        width={400}
      >
        <TextField
          label="File Contents"
          multiline
          variant="outlined"
          fullWidth
          minRows={10}
          onChange={handleFileContentsChange}
        />
      </Box>

      <Box
        width={400}
      >
        <TextField
          multiline
          variant="outlined"
          fullWidth
          minRows={10}
          disabled
          value={diff}
          sx={{
            backgroundColor: '#EEF'
          }}
        />
      </Box>
      </Box>

      <Box
        display="flex"
        alignItems="center"
      >
        <Box paddingTop={2}
          paddingRight={1}
          display="flex"
          flexDirection="column"
          alignItems="stretch"
          width={300}
        >
          <Box paddingBottom={2} fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                sendGet(`init/${uid}`);
              }}
            >
              Create User
            </Button>
          </Box>
          
          <Box paddingBottom={2} fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                const payload = `{
                  "fileName" : "${fileName}",
                  "fileContents" : ${JSON.stringify(fileContents)}
                }`;
                sendPost(`${uid}/${pid}`, payload);
              }}
            >
              Write to File
            </Button>
          </Box>

          <Box fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                sendGet(`file_exist/${uid}/${pid}/${fileName}`)
              }}
            >
              File Exists in Project?
            </Button>
          </Box>
        </Box>

        <Box paddingTop={2}
          paddingLeft={1}
          display="flex"
          flexDirection="column"
          alignItems="stretch"
          width={300}
        >
          <Box paddingBottom={2} fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                sendGet(`init/${uid}/${pid}`);
              }}
            >
              Create Project
            </Button>
          </Box>

          <Box paddingBottom={2} fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                getDiff(`diff/${uid}/${pid}/${fileName}`);
              }}
            >
              Diff File
            </Button>
          </Box>
          
          <Box fullWidth>
            <Button
              variant="contained"
              fullWidth
              onClick={() => {
                sendGet(`required_files/${uid}/${pid}`);
              }}
            >
              Required Files in Project?
            </Button>
          </Box>
        </Box>

      </Box>

      <Box paddingTop={6}
        display="flex"
        flexDirection="column"
        alignItems="center"
        sx={{
          lineHeight: 0
        }}
      >
        <h2>Raw JSON</h2>
        <p>{response}</p>
      </Box>

    </Box>
  );
}

export default App;
