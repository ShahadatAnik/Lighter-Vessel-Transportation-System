
import Axios from 'axios';
import { sha256, sha224 } from 'js-sha256';
import { BrowserRouter, Routes, Route, useNavigate } from "react-router-dom";
import React, {useEffect, useState} from 'react';
export default function Login(){
    const navigate = useNavigate();
  const [isInvalidEmail, setIsInvalidEmail] = React.useState(false);
  const [isInvalidPassword, setIsInvalidPassword] = React.useState(false);
  const [isLoading, setLoading] = useState(false);
  // const [verify_code, setVerify_code] = React.useState('');
  // const [generatedcode, setGeneratedcode] = React.useState('');
  const [user, setUser] = React.useState({
    username: '',
    password: '',
  });

  const [show, setShow] = React.useState('password');

//   useEffect(() => {
//     setGeneratedcode(makeid(5));
//   },[]);

const loading = e => {
  setLoading(true);
}
if (isLoading) {
  return <div className="App">Loading...</div>;
}

  const handleInput = e => {
    const { name, value } = e.target;

    // if (name === 'email') {
    //   if (!value.includes('@')) {
    //     setIsInvalidEmail(true);
    //   } else {
    //     setIsInvalidEmail(false);
    //   }
    // }
    if (name === 'password') {
      if (value.length < 6) {
        setIsInvalidPassword(true);
      } else {
        setIsInvalidPassword(false);
      }
    }
    setUser(prevState => ({
      ...prevState,
      [name]: value,
    }));
  };

  const onSubmit = e => {
     loading();
    if (isInvalidEmail || isInvalidPassword) {
      e.preventDefault();
    }
  //   else if(generatedcode != verify_code){
  //     // console.log(generatedcode)
  //     // console.log(verify_code)
  //     alert('Wrong verification code')
  // }
  else{
      //console.log(user.email);
      Axios.get("http://localhost:3001/user/verify_login/", {
        params: {
            username: user.username,
            password: sha256(user.password),
        }
    }).then((response) => {
      setLoading(false);
      //console.log("Data"+response.data)
      if(response.data === "No user found"){
      alert("No user found");
    }else if(response.data=="wrong password"){
      alert("Wrong password");
    }else{
      console.log("Logged in");
      localStorage.setItem('loggedin', 'true');
      const user = response.data.split(":");
      console.log(user[0]);
      console.log(user[1]);
      localStorage.setItem('user_id', user[0]);
      localStorage.setItem('user_type', user[1]);
      window.location.href = "/..";
    }
  });
    }
  };
    return (
      <div>
      <div class="rounded-lg shadow-lg bg-white w-full max-w-lg mx-auto p-8 md:p-12 my-10">
          <h2 class="text-2xl font-bold text-center mb-8">Login</h2>
          <form onSubmit={onSubmit}>
              
              <div class="mb-6">
                  <input
                      type="text"
                      class="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                      id="emailAddress"
                      placeholder="Username"
                      name="username"
                    onChange={handleInput}
                  />
              </div>
              <div class="mb-6">
                  <input
                      type="password"
                      class="form-control block w-full px-4 py-2 text-xl font-normal text-gray-700 bg-white bg-clip-padding border border-solid border-gray-300 rounded transition ease-in-out m-0 focus:text-gray-700 focus:bg-white focus:border-blue-600 focus:outline-none"
                      id="password"
                      placeholder="Password"
                        name="password"
                        isInvalid={isInvalidPassword}
                        onChange={handleInput}
                  />
              </div>
              {/*<div class="mb-6">
                    <input id="outlined-basic" label="Verification code" type="text" name="productName" onChange={(e)=>{
        setVerify_code(e.target.value)
      }}/>   <button type="button" onClick = {()=>{verifyEmail()}}>Send verification code</button><br></br>
                        </div>
    */}
              <div class="text-center lg:text-left">
                  <button 
                  
                      type="submit"
                      class="inline-block px-7 py-3 bg-blue-600 text-white font-medium text-sm leading-snug uppercase rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
                  >
                      Login
                  </button>
                  <p class="text-sm font-semibold mt-2 pt-1 mb-0">
                      Don't have an account? 
                      <a
                          href="/signup"
                          class="text-red-600 hover:text-red-700 focus:text-red-700 transition duration-200 ease-in-out"
                      >
                          Signup
                      </a>
                  </p>
              </div>
          </form>
      </div>
  </div>
    );
}