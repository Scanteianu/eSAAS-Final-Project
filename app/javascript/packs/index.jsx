// Run this example by adding <%= javascript_pack_tag 'index' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';
import App from '../components/App';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { ChakraProvider } from '@chakra-ui/react'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
      <ChakraProvider>
        <Router>
          <Route path="/" component={App} />
        </Router>
      </ChakraProvider>,
    document.body.appendChild(document.createElement('div')),
  )
})
