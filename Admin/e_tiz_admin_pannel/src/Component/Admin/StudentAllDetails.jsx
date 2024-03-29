import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import ImagePreviewModal from '../Admin/ImagePreviewModal';
import Modal from 'react-modal';
import 'bootstrap/dist/css/bootstrap.min.css';
import { useNavigate } from 'react-router-dom';
import NavBar from './NavBar';
import axios from 'axios';

const StudentAllDetails = () => {
    const { id } = useParams();
    const token =  sessionStorage.getItem('token');
    const adminId = sessionStorage.getItem('adminId')
    const [item, setItem] = useState(null);
    const [selectedImage, setSelectedImage] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [reason, setReason] = useState('');
    const [isModalOpen1, setIsModalOpen1] = useState(false);
    const [fileDownloaded, setFileDownloaded] = useState(false);
      const [requesActivetData, setRequesActivetData] = useState({
      status: true,
      id: null,
      adminId: ""
    });
    const navigate = useNavigate();
  
    useEffect(() => {
      const fetchItem = async () => {
        try {
          const response = await fetch(`http://localhost:8080/api/v1/admin/getStudentAllDetails/${id}`);
          const data = await response.json();
          setItem(data);
        } catch (error) {
          console.error('Error fetching items:', error);
        }
      };
      fetchItem();
    }, [id]);
  
    const openImagePreview = (imageSrc) => {
      setSelectedImage(imageSrc);
    };
  
    const closeImagePreview = () => {
      setSelectedImage(null);
    };
  
    if (!item) {
      return <div>Loading...</div>;
    }
  
    const handleDelete = async (itemRole) => {
      try {
        const role= item.roles.toString();
        const response = await fetch(`http://localhost:8080/api/v1/admin/removeUser/${id}/${adminId}`, {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },body: JSON.stringify({reason,role})
        });
  
        if (response.ok) {
          console.log('Delete operation successful');
            setTimeout(() => {
              window.location.reload();
            }, 1000);    
            alert('Remove operation successful') 
            navigate(`/generalUserDetails`);
        } else {
          console.error('Remove operation failed');
          alert('Remove operation failed')
        }
      } catch (error) {
        console.error('Error during remove operation', error);
        alert('Error during remove operation')
      }
    };
  
    const handleActive = async () => {
      try {
              const data = {
                status: true,
                id: item.id,
                adminId: adminId 
              };
  
        const response = await fetch(`http://localhost:8080/api/v1/admin/setUserStatus/generateQRCode/${id}/${adminId}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
          },
          body: JSON.stringify(data),
        });
  
        if (response.ok) {
          console.log('Active the User');
          
            setTimeout(() => {
              window.location.reload();
            }, 1000);    
            alert('User has been Activated') 
            navigate(`/generalUserDetails`);
        } else {
          console.error('Activate operation failed');
          alert('Activate operation failed')
        }
      } catch (error) {
        console.error('Error during delete operation', error);
        alert('Error during delete operation')
      }
    };
  
    const handleButtonClick = () => {
      setIsModalOpen(true);
    };
  
    const closeModal = () => {
      setIsModalOpen(false);
    };
  
    const handleButtonClick1 = () => {
      setIsModalOpen1(true);
    };
  
    const closeModal1 = () => {
      setIsModalOpen1(false);
    };
  
    const modalStyle = {
      content: {
        width: '50%', 
        top: isModalOpen ? '50%' : '-100%', 
        left: '50%',
        transform: 'translate(-50%, -50%)',
        transition: 'top 0.3s ease-in-out', 
        zIndex: 2000, 
        border: '10px solid #FFD700',
        opacity:0.75,
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
        opacity:0.75,
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
    const handleChange = (event) => {
      event.preventDefault(); // Prevent default form submission behavior
      setReason(event.target.value)
  
    };

    const handleApprovalLetter = async () => {
        try {
            const name = item.fullName;
          const response = await axios.get(`http://localhost:8080/api/v1/admin/approvalLetter/${id}`, {
            responseType: 'blob',
            headers: {
                'Authorization': `Bearer ${token}`, 
                'Content-Type': 'application/json', 
              }, 
          });
          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', `approval_letter_${name}.pdf`);
          document.body.appendChild(link);
          link.click();
          setFileDownloaded(true);
        } catch (error) {
          console.error('Error downloading PDF:', error);
          // Handle error
        }
      };

      
    const handleBirthPDF = async () => {
        try {
            const name = item.fullName;
          const response = await axios.get(`http://localhost:8080/api/v1/admin/studentBirthPDF/${id}`, {
            responseType: 'blob', 
            headers: {
                'Authorization': `Bearer ${token}`, 
                'Content-Type': 'application/json', 
              },
          });
          const url = window.URL.createObjectURL(new Blob([response.data]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', `birth_certificate_${name}.pdf`);
          document.body.appendChild(link);
          link.click();
          setFileDownloaded(true);
        } catch (error) {
          console.error('Error downloading PDF:', error);
          // Handle error
        }
      };
  return (
<> 
<center><div className='container m-4'><NavBar /></div></center>
        <div className='container'>
        <div className='container m-4'>
        <div className='row'>
            <div className='col-12 m-4'>
            <div className='fs-5 text-center'>USER PHOTO</div>
            <center>{item && (
                <img
                className="no-border img-fluid img-thumbnail bg-image hover-zoom border border-danger rounded"
                src={`data:${item.photoType};base64,${item.photoData}`}
                style={{ width: '200px', maxHeight: '200px', cursor: 'pointer' }}
                alt={item.title}
                onClick={() =>
                    openImagePreview(
                    `data:${item.photoType};base64,${item.photoData}`
                    )
                }
                />
            )}</center>
            </div>


        </div>
        </div>
            <div className='col-12 '>
                <div className='row rounded m-4 border border-danger rounded'>
                    <div className='col-4 border' style={{ backgroundColor: '#F5F5F5' }}>
                    <div className='fs-3 my-2 font-weight-bold text-center'><b>Personal Details</b></div>
                        <div className='fs-4 m-3'>Full Name: {item.fullName || 'No title available'}</div>
                        <div className='fs-4 m-3'>int Name: {item.intName || 'No model available'}</div>
                        <div className='fs-4 m-3'>Date of Birth: {item.dob || 'No device type available'}</div>
                        <div className='fs-4 m-3'>Address: {item.address || 'No condition available'}</div>
                        <div className='fs-4 m-3'> Gender: {item.gender || 'No brand available'}</div>
                        <div className='fs-4 m-3'>telephoneNumber: {item.telephoneNumber || 'No price available'}</div>
                        <div className='fs-4 m-3'>Residence: {item.residence || 'No phone number available'}</div>
                        <div className='fs-4 m-3'>Status: {item.status || 'No date available'}</div>
                        <div className='fs-4 m-3'>Role: {item.roles || 'No date available'}</div>
                    </div>
                    <div className='col-4 ' style={{ backgroundColor: '#E0FFFF' }}>
                        <div className=''>
                            <center><div className='fs-3 m-3'><b>School Details</b></div></center>
                            <div className='fs-5 m-3'>Address of the school: {item.schAddress || 'No place available'}</div>
                            <div className='fs-5 m-3'>District: {item.district || 'No title available'}</div>              
                            <div className='fs-5 m-3'>Index Number: {item.indexNumber || 'No description available'}</div>         
                        </div><hr/>

                        <div className=''>
                            <center><div className='fs-3 m-3'><b>Guardian Details</b></div></center>
                            <div className='fs-5 m-3'>Name of The Guardian: {item.nameOfGuardian || 'No place available'}</div>
                            <div className='fs-5 m-3'>Relation: {item.guardianType || 'No title available'}</div>              
                            <div className='fs-5 m-3'>Occupation: {item.occupation || 'No description available'}</div>
                            <div className='fs-5 m-3'>Contact Number: {item.contactNumber || 'No model available'}</div>          
                        </div>

                    </div>
                    
                    <div className='col-4 ' style={{ backgroundColor: '#F5F5F5' }}>
                        <div>
                            <center><div className='fs-3 m-3'><b>Journey Details</b></div></center>
                            <div className='fs-4 m-3'>Route: {item.route || 'No place available'}</div>
                            <div className='fs-4 m-3'>Nearest Deport: {item.nearestDeport || 'No title available'}</div>              
                            <div className='fs-4 m-3'>Distance: {item.distance || 'No description available'}</div>
                            <div className='fs-4 m-3'>Charge: {item.charge || 'No model available'}</div>
                        </div> <hr/>
                        <div>
                        <center><div className='fs-3 m-3'><b>Documents</b></div></center>
                        <center><button className='btn btn-success m-4' onClick={handleApprovalLetter}>Principle Approval Letter</button></center>
                        <center><button className='btn btn-success m-4' onClick={handleBirthPDF}>Student Birth Certificate</button></center>
                        </div>
                    </div>
                       
                </div>
            </div>
        <ImagePreviewModal
        isOpen={!!selectedImage}
        onClose={closeImagePreview}
        imageSrc={selectedImage}
        altText={item.title}
        />

        <div className='container'>
        <div className='row'>
            <div className='col-5 mx-2'>
            <center><button className='btn btn-warning mb-4 p-3'onClick={handleButtonClick}>Remove</button></center>
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
                                <button onClick={() => { handleDelete(item.roles.toString()); closeModal(); }} disabled={!reason.trim()}>Yes</button>
                            </div>
                            <div className='col-2 '>
                                <button onClick={closeModal}>No</button>
                            </div>                    
                    </div>                 
                </Modal>
            </div>

            <div className='col-5 mx-2'>
            {item.status.toLowerCase().trim() == 'pending' ? 
            <center><button className='btn btn-warning mb-4 p-3'onClick={handleButtonClick1}>Active</button></center>  : null}
                <Modal
                    className='bg-dark'
                    shouldCloseOnOverlayClick={true}
                    isOpen={isModalOpen1}
                    shouldCloseOnEsc={true}
                    onRequestClose={closeModal1}
                    contentLabel="Example Modal"
                    style={modalStyle1}>
                    <div className='fs-1 text-info bg-dark text-center '>Alert!</div>
                                <div className='fs-4 text-info bg-dark text-center my-3'>Are you sure to Active this user, which name is {item.fullName}?</div>
                            <div className='row bg-dark my-3'>
                            <div className='col-4'>
                            </div>
                            <div className='col-2 '>
                                <button onClick={() => { handleActive(); closeModal1(); }} >Yes</button>
                            </div>
                            <div className='col-2 '>
                                <button onClick={closeModal1}>No</button>
                            </div>                    
                    </div>                 
                </Modal>
            </div>
        </div>
        </div>
    </div>
</>
  )
}

export default StudentAllDetails