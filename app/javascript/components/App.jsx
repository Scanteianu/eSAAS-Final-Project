import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import AppBar from './AppBar';
import Carts from './carts/Carts';
import Cart from './carts/Cart'
import './styles/App.css';

const App = () => {
  return(
    <Router>
      <AppBar appName={'FoodTrucker'} />
      <Switch>
        <Route exact path="/carts">
          <Carts />
        </Route>        
        <Route exact path="/carts/:id">
          <Cart />
        </Route>
      </Switch>
    </Router>
  );
};

export default App;
