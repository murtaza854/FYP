import React, { useState, useEffect } from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";
import './App.scss';
import Routes from './Routes';
import UserContext from "./contexts/userContext";
// import Auth from './auth/Auth';
import api from './api';

function App() {
  const [userState, setUserState] = useState(null);
  // const [loading, setLoading] = useState(true);

  useEffect(() => {
    (
      async () => {
        try {
          const response = await fetch(`${api}/logged-in`, {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
            },
            credentials: 'include',
            withCredentials: true,
          });
          const content = await response.json();
          const user = content.data;
          const { displayName, email, emailVerified, accountSetup, admin, provider } = user;
          console.log(user)
          setUserState({ displayName, email, emailVerified, accountSetup, admin, provider });
          // setLoading(false);
        } catch (error) {
          setUserState(null);
          // setLoading(false);
        }
      })();
  }, []);

  // if (loading) return <div></div>

  return (
    <UserContext.Provider value={{ userState: userState, setUserState: setUserState }}>
      <Router>
        <Switch>
          <Route path="*">
            <Routes />
          </Route>
        </Switch>
      </Router>
    </UserContext.Provider>
  );
}

export default App;
