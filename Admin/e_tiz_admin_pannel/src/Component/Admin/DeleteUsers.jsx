import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import NavBar from './NavBar';
import axios from 'axios';

const ITEMS_PER_PAGE = 12;

const ItemList = () => {
    const token = sessionStorage.getItem('token');
    const adminId = sessionStorage.getItem('adminId')
  const [items, setItems] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [searchResult, setSearchResult] = useState([]);
  const [showNoResultsMessage, setShowNoResultsMessage] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [filter, setFilter] = useState('all'); 

  useEffect(() => {
    // Fetch items from the backend API
    const fetchItems = async () => {
      try {
        const response = await fetch('http://localhost:8080/api/v1/admin/getDeleteUsersDetails',{
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          }
        });
        const data = await response.json();
        setItems(data);
      } catch (error) {
        console.error('Error fetching items:', error);
      }
    };

    fetchItems();
  }, []);

  const [roles, setroles] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
    
      try {   
          const rolesResponse = await axios.get('http://localhost:8080/api/v1/admin/getRoles', {
            headers: {    
                'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`,       
            }
          });  
          const rolesArray = rolesResponse.data;
          setroles(rolesArray); 
      } catch (error) {
        console.error('Error fetching device types and brands:', error.message);
      }
    };

    fetchData();
  }, []);

  const handleFilterChange = (event) => {
    const selectedFilter = event.target.value;
    setFilter(selectedFilter);
};

const filteredItems = items.filter(item => {
    if (filter === 'all') {
      return true;
    }
    return item.role === filter;
  });
  

  const generateSearchVariations = (term) => {
    const variations = [];
    const cleanedTerm = term.replace(/[^\w\s]/gi, ''); // Remove symbols

    // Original term
    variations.push(cleanedTerm);

    // Remove spaces
    variations.push(cleanedTerm.replace(/\s/g, ''));

    // Split by spaces and join without spaces
    variations.push(cleanedTerm.split(/\s/).join(''));

    return variations;
  };

  const handleSearch = () => {
    // Reset to the first page when a new search is performed
    setCurrentPage(1);
    // Generate search term variations
    const searchVariations = generateSearchVariations(searchTerm.toLowerCase());
   // Filter items based on the cleaned search term
const filteredItems = items.filter(item => {
  const cleanedTitle = item.userName.toLowerCase().replace(/[^\w\s]/gi, ''); // Remove symbols
  const matchesSearch = searchVariations.some(variation => cleanedTitle.includes(variation));

  return roles.some(role=> {
    if (role.selected) { 
      return filter === role && item.role === role && matchesSearch;
    } else {
      return true && matchesSearch;
    }
  });
});


  setSearchResult(filteredItems);
    // Update the state to show the message only if no results are found and the search button is clicked
    setShowNoResultsMessage(filteredItems.length === 0 && searchTerm !== '');
  };

  const handleInputChange = (e) => {
    const newSearchTerm = e.target.value;
    setSearchTerm(newSearchTerm);

    // Automatic filtering as the user types
    const cleanedSearchTerm = newSearchTerm.replace(/[^\w\s]/gi, ''); // Remove symbols
    const filteredItems = items.filter(item => {
      const cleanedTitle = item.userName.toLowerCase().replace(/[^\w\s]/gi, '')+ item.role.toLowerCase().replace(/[^\w\s]/gi, ''); // Remove symbols
      const matchesSearch = ( cleanedTitle.includes(cleanedSearchTerm));

      return roles.some(role => {
        if (role.selected) { 
          return filter === role && item.role=== role && matchesSearch;
        } else {
          return true && matchesSearch;
        }
      });
      });

    setSearchResult(filteredItems);
    setShowNoResultsMessage(false);
  };

  const textStyle = {
    color: '#FFD700',
    fontWeight: 'bold',
    userSelect: 'none', // Add this line to disable text selection
  };

  // Calculate the index range for the current page
  const indexOfLastItem = currentPage * ITEMS_PER_PAGE;
  const indexOfFirstItem = indexOfLastItem - ITEMS_PER_PAGE;
  const currentItems = (searchResult.length > 0 ? searchResult : filteredItems).slice(indexOfFirstItem, indexOfLastItem);

  // Update page number
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  return (
    <>
     
      <div className='container'><NavBar /></div>
       <center><h1 className="no-focus-outline">Delete Users' List</h1></center>

      <div className='container m-4'>
        <div className='d-flex m-4 '>

          <div className='input-group mb-3 '>
            <label htmlFor="search" className='d-none d-sm-block input-group-append mx-3 my-2'>Search by name: </label>
            <input
            class="form-control rounded"
              placeholder="Search"
              aria-label="Search"
              type="text"
              id="search"
              value={searchTerm}
              onChange={handleInputChange}
            />
            <button className="btn m-2 my-sm-0 btn-outline-secondary input-group-append mx-2" type="button" onClick={handleSearch} >
              Search
            </button>
            <div className="mx-4">
            <select className="form-select" value={filter} onChange={handleFilterChange}>
                <option value="all">All Users</option>
                {roles.map((role, index) => (
                  <option key={index} value={role}>{role}</option>
                ))}
              </select>
            </div>
          </div>

        </div>
      </div>
    <div className='m-3'>
            {showNoResultsMessage && (
        <h4 style={textStyle}>No results found for "{searchTerm}".</h4>
      )}
    </div>

        <div className='container-fluid  m-4 view overlay zoom rounded'>
          <div className='row px-2 mx-4'>
            
        {currentItems.map(item => (
            
              <div className='col-5 p-4 mx-4 my-2 zoom-opacity-effect' key={item.id} >                                                                           
                  <div className='row border'>
                    <div className='col-12  mr-4 text-light bg-dark'>
                      <h2 className='text-center fs-3  m-2 ' >{item.userName}</h2>
                      <div className="fs-5 fw-light border  m-2"><b>Full Name: {item.fullName}</b></div>
                      <div className="fs-5 fw-light border  m-2">Admin ID who This Account removed  : {item.adminId}</div>
                      <p class=" fs-5 border  m-2">Reason: {item.reason}</p>
                      <p class=" fs-5 border  m-2">Role: {item.role}</p>                     
                      <p class=" fs-5 border  m-2">Account Removed Date: {item.deleteDate}</p>
                      
                    </div>                    
                  </div>                 
              </div>                               
        ))}</div> </div>
      

      {/* Pagination */}
      <div className='container-fulid m-4'>
        <div className='row'>
        <div className='col-5'></div>
      <nav className='col-3'>
        <ul className="pagination">
          <li className={`page-item ${currentPage === 1 ? 'disabled' : ''}`}>
            <button className="page-link" onClick={() => paginate(currentPage - 1)}>
              Previous
            </button>
          </li>
          {[...Array(Math.ceil((searchResult.length > 0 ? searchResult : items).length / ITEMS_PER_PAGE)).keys()].map((number) => (
            <li key={number + 1} className={`page-item ${currentPage === number + 1 ? 'active' : ''}`}>
              <button className="page-link" onClick={() => paginate(number + 1)}>
                {number + 1}
              </button>
            </li>
          ))}
          <li className={`page-item ${currentPage === Math.ceil((searchResult.length > 0 ? searchResult : items).length / ITEMS_PER_PAGE) ? 'disabled' : ''}`}>
            <button className="page-link" onClick={() => paginate(currentPage + 1)}>
              Next
            </button>
          </li>
        </ul>
      </nav>
      <div className='col-4'></div>
      </div>
      </div>
    </>
  );
};

export default ItemList;
