import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Carts from './carts/Carts';
import Cart from './carts/Cart'

const App = () => {
  return(
    <Router>
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
