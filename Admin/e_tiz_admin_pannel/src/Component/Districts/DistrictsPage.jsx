import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useNavigate } from 'react-router-dom';
import Modal from 'react-modal';
import NavBar from '../Admin/NavBar';
import axios from 'axios';

const ITEMS_PER_PAGE = 6;

const DistrictsPage = () => {
    const token = sessionStorage.getItem('token');
    const adminId = sessionStorage.getItem('adminId')
    const navigate = useNavigate();
    const [items, setItems] = useState([]);
    const [name, setName] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [searchResult, setSearchResult] = useState([]);
    const [showNoResultsMessage, setShowNoResultsMessage] = useState(false);
    const [currentPage, setCurrentPage] = useState(1);
    const [reason, setReason] = useState('');
    const [newAdd, setNewAdd] = useState('');
    const [update, setUpdate] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [isModalOpen1, setIsModalOpen1] = useState(false);
    const [isModalOpen2, setIsModalOpen2] = useState(false);
    const [itemId, setItemId] = useState('');

    useEffect(() => {
        // Fetch items from the backend API
        const fetchItems = async () => {
            const BearerToken = token;
            try {
                const response = await fetch(`http://localhost:8080/api/v1/admin/getAllSchDistrict`, {
                    headers: {
                        'Authorization': `Bearer ${BearerToken}`,
                        'Content-Type': 'application/json',
                    },
                });
                const data = await response.json();
                setItems(data);
            } catch (error) {
                console.error('Error fetching items:', error);
            }
        };

        fetchItems();
    }, []);
    const handleAddConductors  = () => {
            navigate(`/addConductor`);
       
    };
    const handleSearch = () => {
        // Reset to the first page when a new search is performed
        setCurrentPage(1);

        // Filter items based on the cleaned search term
        const filteredItems = items.filter(item => {
            const cleanedTitle = item.userName.toLowerCase().replace(/[^\w\s]/gi, ''); // Remove symbols
            return cleanedTitle.includes(searchTerm.toLowerCase());
        });

        setSearchResult(filteredItems);

        // Update the state to show the message only if no results are found and the search button is clicked
        setShowNoResultsMessage(filteredItems.length === 0 && searchTerm !== '');
    };

    const handleDeleteOnes = () => {
        navigate(`/deletedDistricts`);
    };

    const handleInputChange = (e) => {
        const newSearchTerm = e.target.value;
        setSearchTerm(newSearchTerm);

        // Automatic filtering as the user types
        const filteredItems = items.filter(item => {
            const cleanedTitle = item.userName.toLowerCase().replace(/[^\w\s]/gi, ''); // Remove symbols
            return cleanedTitle.includes(newSearchTerm.toLowerCase());
        });

        setSearchResult(filteredItems);
        setShowNoResultsMessage(false);
    };

    const handleButtonClick = () => {
        setIsModalOpen(true);
    };

    const handleButtonClick2 = () => {
        setIsModalOpen2(true);
    };

    const handleButtonClick1 = () => {
        setIsModalOpen1(true);
    };

    const closeModal1 = () => {
        setIsModalOpen1(false);
    };

    const closeModal = () => {
        setIsModalOpen(false);
    };

    const closeModal2 = () => {
        setIsModalOpen2(false);
    };

    const handleUpdate = async () => {
        try {
          const response = await axios.put(`http://localhost:8080/api/v1/admin/updateSchoolDistrict/${itemId}`,{
            districtName: update, 
          adminId: adminId,
          }, {
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`,
            }
          });
    
          if (response.status === 200) {
            console.log('Upate operation successful');
              setTimeout(() => {
                window.location.reload();
              }, 1000);    
              alert('Update operation successful') 
          } else {
            console.error('update operation failed');
            alert('update operation failed')
          }
        } catch (error) {
          console.error('Error during Update operation', error);
          alert('Error during Update operation')
        }
      };

      const handleAdd = async () => {
        try {
          const response = await axios.post(`http://localhost:8080/api/v1/admin/addSchoolDistrict`,{
            districtName: newAdd, 
          }, {
            headers: {
              'Content-Type': 'application/json',
              'Authorization': `Bearer ${token}`,
            }
          });
    
          if (response.status === 200) {
            console.log('Adding operation successful');
              setTimeout(() => {
                window.location.reload();
              }, 1000);    
              alert('Adding operation successful') 
          } else {
            console.error('Adding operation failed');
            alert('Adding operation failed')
          }
        } catch (error) {
          console.error('Error during ADD operation', error);
          alert('Error during " ADD "operation')
        }
      };

      const handleDelete = async () => {
        try {
          const response = await axios.delete(
            `http://localhost:8080/api/v1/admin/deleteSchoolDistrict/${itemId}`,
            {
              data: {
                reason: reason,
                adminId: adminId,
              },
              headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
              },
            }
          );
      
          if (response.status === 200) {
            console.log('Delete operation successful');
            setTimeout(() => {
              window.location.reload();
            }, 1000);
            alert('Remove operation successful');
          } else {
            console.error('Remove operation failed');
            alert('Remove operation failed');
          }
        } catch (error) {
          console.error('Error during remove operation', error);
          alert('Error during remove operation');
        }
      };

      

    const handleChange = (event) => {
        event.preventDefault(); // Prevent default form submission behavior
        setReason(event.target.value)
    };

    const handleChange2 = (event) => {
        event.preventDefault(); // Prevent default form submission behavior
        setNewAdd(event.target.value)
    };

    const handleChange1 = (event) => {
        event.preventDefault(); // Prevent default form submission behavior
        setUpdate(event.target.value)
    };

    const handleItemId =(id) =>{
        setItemId(id);
    }

    // Calculate the index range for the current page
    const indexOfLastItem = currentPage * ITEMS_PER_PAGE;
    const indexOfFirstItem = indexOfLastItem - ITEMS_PER_PAGE;
    const currentItems = (searchResult.length > 0 ? searchResult : items).slice(indexOfFirstItem, indexOfLastItem);

    // Update page number
    const paginate = (pageNumber) => setCurrentPage(pageNumber);

    const modalStyle = {
        content: {
            width: '50%',
            top: isModalOpen ? '50%' : '-100%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            transition: 'top 0.3s ease-in-out',
            zIndex: 2000,
            border: '10px solid #FFD700',
            opacity: 0.75,
            fontWeight: 'bold',
            borderRadius: '10px',
            padding: '20px',
            position: 'relative',
        },
        overlay: {
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
            transition: 'background-color 0.3s ease-in-out',
        },
    };

    const modalStyle2 = {
        content: {
            width: '50%',
            top: isModalOpen2 ? '50%' : '-100%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            transition: 'top 0.3s ease-in-out',
            zIndex: 2000,
            border: '10px solid #FFD700',
            opacity: 0.75,
            fontWeight: 'bold',
            borderRadius: '10px',
            padding: '20px',
            position: 'relative',
        },
        overlay: {
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
            transition: 'background-color 0.3s ease-in-out',
        },
    };

    const modalStyle1 = {
        content: {
            width: '50%',
            top: isModalOpen1 ? '50%' : '-100%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            transition: 'top 0.3s ease-in-out',
            zIndex: 2000,
            border: '10px solid #FFD700',
            opacity: 0.75,
            fontWeight: 'bold',
            borderRadius: '10px',
            padding: '20px',
            position: 'relative',
        },
        overlay: {
            backgroundColor: 'rgba(0, 0, 0, 0.5)',
            transition: 'background-color 0.3s ease-in-out',
        },
    };

    
  const textStyle = {
    fontWeight: 'bold',
    userSelect: 'none',
  };

    return (
        <>
           <cenetr><div className='container my-4'><NavBar /></div></cenetr>
           <div className='fs-4 text-center'><b>Districts</b></div>
            <div className='container'>
                <div className=' my-4 row '>
                    <div className='col-lg-8'>
                    <div className='input-group mb-3'>
                        <label htmlFor="search" className='d-none d-sm-block input-group-append mx-3' style={textStyle}>Search by Name: </label>
                        <input
                            className="form-control rounded"
                            placeholder="Search"
                            aria-label="Search"
                            type="text"
                            id="search"
                            value={searchTerm}
                            onChange={handleInputChange}
                        />
                        <button className="btn m-2 my-sm-0 btn-outline-secondary input-group-append mx-2" type="button" onClick={handleSearch} style={textStyle}>
                            Search
                        </button>

                    </div></div>
                    <div className='col-lg-2'>                       
                    <button className="btn m-2 my-sm-0 btn-outline-secondary mr-4" type="button" onClick={handleButtonClick2} style={textStyle}>
                            Add a New District
                    </button>
                    <Modal
                        className='bg-dark'
                        shouldCloseOnOverlayClick={true}
                        isOpen={isModalOpen2}
                        shouldCloseOnEsc={true}
                        onRequestClose={closeModal2}
                        contentLabel="Example Modal"
                        style={modalStyle2}>
                            <div className='fs-1 text-info bg-dark text-center '>Attention</div>
                                <div className='fs-4 text-info bg-dark text-center my-3'>Add new district via input field and press "yes" button.</div>
        
                                <input type="text" name="nickName" value={newAdd} onChange={handleChange2} class="form-control" required  />           
                                            <div className='row bg-dark my-3'>
                                            <div className='col-4'>
                                                </div>
                                                    <div className='col-2 '>
                                                        <button onClick={() => { handleAdd(); closeModal2(); }} disabled={!newAdd.trim()}>Yes</button>
                                            </div>
                                        <div className='col-2 '>
                                            <button onClick={closeModal2}>No</button>
                                        </div>                    
                                </div>                 
                            </Modal>                   
                </div> 
                <div className='col-lg-2'><button className="btn m-2 my-sm-0 btn-outline-secondary mr-4" type="button" onClick={handleDeleteOnes} style={textStyle}>Delete Districts</button></div>

                </div>
            </div>
            <div className='m-3'>
                {showNoResultsMessage && (
                    <h4 style={textStyle}>No results found for "{searchTerm}".</h4>
                )}

            </div>


             <div className='container-fluid '>  
             <div className='row'>
                {currentItems.length !== 0 ? currentItems.map(item => (
                                       
                            <div key={item.id} className='col-lg-3 col-md-5 col-sm-12 border m-4 border-3 border-secondary'>
                                <div className='row my-2 font-weight-bold text-dark'>    
                                    <div className='col-lg-12 col-md-6'>                                                                         
                                            <div className='col-lg-12 col-md-6  my-3 font-weight-bold text-dark'>
                                                    <div className="fs-5 text-center">District Name: {item.district}</div>                                                                          
                                        </div>        
                                    </div>
                                </div> 
                                <div className='row'>
                                    <div className='col-lg-6 col-md-4 my-4'>
                                        <center><button className='btn btn-warning' onClick={() => {handleButtonClick1(); handleItemId(item.id);}}>Edit</button></center>
                                        <Modal
                                            className='bg-dark'
                                            shouldCloseOnOverlayClick={true}
                                            isOpen={isModalOpen1}
                                            shouldCloseOnEsc={true}
                                            onRequestClose={closeModal1}
                                            contentLabel="Example Modal1"
                                            style={modalStyle1}>
                                            <div className='fs-1 text-info bg-dark text-center '>Attention</div>
                                                        <div className='fs-5 text-info bg-dark text-center my-3'>If you want to update <b>{item.district}</b> district, Please enter the value, which change, on input felid. </div>

                                        <label>   </label>           
                                        <input type="text" name="nickName" value={update} onChange={handleChange1} class="form-control" required  />           

                                                    <div className='row bg-dark my-3'>
                                                    <div className='col-4'>
                                                    </div>
                                                    <div className='col-2 '>
                                                        <button onClick={() => { handleUpdate(); closeModal1(); }} disabled={!update.trim()}>Yes</button>
                                                    </div>
                                                    <div className='col-2 '>
                                                        <button onClick={closeModal1}>No</button>
                                                    </div>                    
                                                </div>                 
                                            </Modal>
                                    </div>  
                                        
                                                    <div className='col-lg-1 col-md-4 my-4 mr-1'>
                                    <center><button className='btn btn-warning 'onClick={() => { handleItemId(item.id); handleButtonClick();}}>Remove</button></center>
                                        <Modal
                                            className='bg-dark'
                                            shouldCloseOnOverlayClick={true}
                                            isOpen={isModalOpen}
                                            shouldCloseOnEsc={true}
                                            onRequestClose={closeModal}
                                            contentLabel="Example Modal"
                                            style={modalStyle}>
                                            <div className='fs-1 text-info bg-dark text-center '>Warning</div>
                                                        <div className='fs-4 text-info bg-dark text-center my-3'>Are you sure to remove this user, which name is {item.fullName}?</div>

                                        <label> Why are you delete this :  </label>           
                                        <input type="text" name="nickName" value={reason} onChange={handleChange} class="form-control" required  />           

                                                    <div className='row bg-dark my-3'>
                                                    <div className='col-4'>
                                                    </div>
                                                    <div className='col-2 '>
                                                        <button onClick={() => { handleDelete(); closeModal(); }} disabled={!reason.trim()}>Yes</button>
                                                    </div>
                                                    <div className='col-2 '>
                                                        <button onClick={closeModal}>No</button>
                                                    </div>                    
                                                </div>                 
                                            </Modal>
                                        </div>                     
                                    </div> 
                                </div>                                                                                   
                           
                                    
                )) : <div className='fs-1 '><center>"Currently, no any district found"</center></div>} 
                </div>
                </div> 
            

            {/* Pagination */}
            <div className='container-fulid m-4 d-flex align-items-end'>
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
}

export default DistrictsPage;
