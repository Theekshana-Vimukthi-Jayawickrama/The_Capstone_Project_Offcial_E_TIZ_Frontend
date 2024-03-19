import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from './NavBar';

const AdminAllDetails = () => {

    const searchParams = new URLSearchParams(useLocation().search);
    const token =  sessionStorage.getItem('token');
    const id = searchParams.get('id')
    const navigate = useNavigate();


     const [item, setItem] = useState(null);

      useEffect(() => {
        const fetchItem = async () => {
          try {
            const response = await fetch(`http://localhost:8080/api/v1/admin/getAdminAllDetails/${id}`, {
              headers: {
                'Authorization': `Bearer ${token}`
              }
            });
            const data = await response.json();
            if (data && data.conductorId) {
              setItem(data);
            } else {
              console.error('Error: Conductor ID not found in data');
            }
          
          } catch (error) {
            console.error('Error fetching items:', error);
          }
        };
        fetchItem();
      }, [id]);


      const [userData, setUserData] = useState({
        fullName: '',
        intName: '',
        telephoneNumber: '',
        dob: '',
        address: '',
        gender: '',
        role:'',
        residence: '',
        photo: null,

      });
      
      useEffect(() => {
        if (item) {
          setUserData({
            fullName: item.fullName|| '',
            intName: item.intName|| '',
            telephoneNumber: item.telephoneNumber || '',
            dob: item.dob || '',
            address: item.address || '',
            gender: item.gender || '',
            role: item.role  || '',
            residence: item.residence || '',
            email: item.email,
            photo: null,
          });
        }
      }, [item]);


      
    return (
    <>
     <cenetr><div className='container my-4'><NavBar /></div></cenetr>
     <div className='container my-4 fs-1'>
        <center>Admin's E-mail: {item && item.email ? item.email.toString() : 'Null'}</center>
    </div>
    <div className='container my-4 fs-1'>
              <div className='row'>
                  <div className='col-lg-12 m-4'>
                    <center><div className='fs-5'>Admin Photo </div></center>
                    <center>{
                        item && item.photoType &&
                        <img
                          className="no-border img-fluid img-thumbnail bg-image hover-zoom"
                          src={`data:${item.photoType};base64,${item.data}`}
                          style={{ width: '400px', maxHeight: '400px' }}
                          alt={item.photoType}
                        />
                      }</center>

                </div>
              </div>
        
        <div className='row my-4 fs-4 '>

          <div className='col-lg-6 col-md-12 d-flex flex-column '>
            <div className='m-1'>Full Name:  {userData.fullName} </div>
            <div className='m-1'>Role:  {userData.role}  </div>
            <div className='m-1'>Date of Birth: {userData.dob} </div>
            <div className='m-1'>Gender: {userData.gender.toUpperCase()} </div>
          </div>

          <div className='col-lg-4 col-md-12 d-flex flex-column'>
            <div className='m-1'>Initial with Name: {userData.intName}</div>
            <div className='m-1'>Residence: {userData.residence} </div>
            <div className='m-1'>Address: {userData.address} </div>
            <div className='m-1'>Telephone Number: {userData.telephoneNumber} </div>
            
          </div>
        </div>
        </div>
      </>
    );
}

export default AdminAllDetails