import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import NavBar from './NavBar';
import axios from 'axios';

const ITEMS_PER_PAGE = 8;

const GeneralUserDetails = () => {
    const [items, setItems] = useState([]);
    const [searchTerm, setSearchTerm] = useState('');
    const [searchResult, setSearchResult] = useState([]);
    const [showNoResultsMessage, setShowNoResultsMessage] = useState(false);
    const [currentPage, setCurrentPage] = useState(1);
    const [filter, setFilter] = useState('all'); // Initial filter value
    const [itemId, setItemId] = useState('');

    useEffect(() => {
        // Fetch items from the backend API
        const fetchItems = async () => {
            try {
                const response = await fetch('http://localhost:8080/api/v1/admin/getAllPendingUsers');
                const data = await response.json();
                setItems(data);
            } catch (error) {
                console.error('Error fetching items:', error);
            }
        };

        fetchItems();
    }, []);

    const handleFilterChange = (event) => {
        const selectedFilter = event.target.value;
        setFilter(selectedFilter);
    };

    // Filter items based on the selected filter
    const filteredItems = items.filter(item => {
        if (filter === 'all') {
            return true; // No filter applied
        } else {
            const [role, status] = filter.split(' ');
            return item.role.includes(role.toUpperCase()) && item.status === status.toLowerCase();
        }
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

        const searchVariations = generateSearchVariations(searchTerm.toLowerCase());

        // Filter items based on the search term
        const filteredItems = items.filter(item => {
            const cleanedTitle = item.userName.toLowerCase().replace(/[^\w\s]/gi, ''); // Remove symbols
            const matchesSearch = searchVariations.some(variation => cleanedTitle.includes(variation));
            if (filter === 'ADULT Pending') {
                return item.status.toString().toLowerCase() == 'pending'&& item.role.toString().toUpperCase() == 'ADULT'  && matchesSearch;
            } else if (filter === 'ADULT Active') {
                return item.status.toString().toLowerCase() == 'active'&& item.role.toString().toUpperCase() == 'ADULT'  && matchesSearch;
            }else if(filter === 'STUDENT Pending'){
                return item.status.toString().toLowerCase() == 'pending'&& item.role.toString().toUpperCase() == 'STUDENT'  && matchesSearch;
            }else if(filter == 'STUDENT Active'){
                return item.status.toString().toLowerCase() == 'active'&& item.role.toString().toUpperCase() == 'STUDENT'  && matchesSearch;
            }
             else {
                return matchesSearch; // 'all' filter, return all items that match the search query
            }
        });

        setSearchResult(filteredItems);
        setShowNoResultsMessage(filteredItems.length === 0 && searchTerm !== '');
    };

    const handleInputChange = (e) => {
        setSearchTerm(e.target.value);
    };
    const handleItemId =(id) =>{
        setItemId(id);
    }

    // Calculate the index range for the current page
    const indexOfLastItem = currentPage * ITEMS_PER_PAGE;
    const indexOfFirstItem = indexOfLastItem - ITEMS_PER_PAGE;
    const currentItems = (searchResult.length > 0 ? searchResult : filteredItems).slice(indexOfFirstItem, indexOfLastItem);

    // Update page number
    const paginate = (pageNumber) => setCurrentPage(pageNumber);
    

    return (
        <>
            <center><div className='container m-4'><NavBar /></div></center>
            <div className='fs-3 text-center my-2'>General User Details</div>

            <div className='container m-4'>
                <div className='d-flex m-4 '>

                    <div className='input-group mb-3 '>
                        <label htmlFor="search" className='d-none d-sm-block input-group-append mx-3'>Search by E-mail: </label>
                        <input
                            className="form-control rounded"
                            placeholder="Search"
                            aria-label="Search"
                            type="text"
                            id="search"
                            value={searchTerm}
                            onChange={handleInputChange}
                        />
                        <button className="btn m-2 my-sm-0 btn-outline-secondary input-group-append mx-2" type="button" onClick={handleSearch}>
                            Search
                        </button>
                        <div className="mx-4">
                            <select className="form-select" value={filter} onChange={handleFilterChange}>
                                <option value="all">All Users</option>
                                <option value="ADULT Pending">Adult Pending</option>
                                <option value="ADULT Active">Adult Active</option>
                                <option value="STUDENT Pending">Student Pending</option>
                                <option value="STUDENT Active">Student Active</option>
                            </select>
                        </div>
                    </div>

                </div>
            </div>
            <div className='m-3'>
                {showNoResultsMessage && (
                    <h4>No results found for "{searchTerm}".</h4>
                )}
            </div>

            <div className='container=fulid m-4'>
            </div>
            <div className='container-fluid   view overlay zoom rounded'>
                <div className='row px-2 mx-4'>
                <div className='row  border border-light'>
                                    <div className='col-2 '>
                                    <h2 className='text-center fs-5 font-weight-bold'>User Photo</h2>  
                                    </div>
                                    <div className='col-4'>
                                        <h2 className='text-center fs-5 font-weight-bold'>Name</h2>                                   
                                    </div>
                                    <div className='col-3'>
                                        <h2 className='text-center fs-5 font-weight-bold'>Role</h2>                                   
                                    </div>
                                    <div className='col-3'>
                                        <h2 className='text-center fs-5 font-weight-bold'>Status</h2>                                   
                                    </div>
                </div>
                    {currentItems.map(item => (
                        <div className='col-12  zoom-opacity-effect rounded' key={item.id} style={{ backgroundColor: 'rgba(10, 70, 10, 0.4)' }}>
                            <Link  to={item.role.toString().toUpperCase() === 'ADULT' ? `/adultAllDetails/${item.id}` : `/studentAllDetails/${item.id}`} className="text-light text-decoration-none ">
                                <div className='row'>
                                    <div className='col-2 py-1'>
                                        <center><img
                                            className="no-border img-fluid img-thumbnail bg-image hover-zoom rounded"
                                            src={`data:${item.photoType};base64,${item.data}`}
                                            style={{ width: '80px', maxHeight: '50px', cursor: 'pointer' }}
                                            alt={item.photoType}
                                        /></center>
                                    </div>
                                    <div className='col-4 '>
                                        <h2 className='text-center fs-5 pt-2 font-weight-bold'>{item.userName}</h2>                                   
                                    </div>
                                    <div className='col-3  mr-4'>
                                        <div className="fs-5 fw-light pt-2 text-center font-weight-bold"><b>{item.role}</b></div>
                                    </div>
                                    <div className='col-3  mr-4'>
                                        <div className="fs-5 fw-light pt-2 text-center ">{item.status.toUpperCase()}</div>
                                    </div>
                                </div>
                            </Link>
                        </div>
                    ))}
                </div>
            </div>

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
    )
}

export default GeneralUserDetails;
