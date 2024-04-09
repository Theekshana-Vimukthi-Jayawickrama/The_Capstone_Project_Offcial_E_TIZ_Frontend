import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from '../Admin/NavBar';

const RouteEdit = () => {

    const searchParams = new URLSearchParams(useLocation().search);
    const token =  sessionStorage.getItem('token');
    const userId = sessionStorage.getItem('userId')
    const id = searchParams.get('id')
    const [telephoneError, setTelephoneError] = useState(''); 
    const navigate = useNavigate();
    const [errorMessage, setErrorMessage] = useState(null);

     const [item, setItem] = useState(null);

      useEffect(() => {
        const fetchItem = async () => {
          try {
            const response = await fetch(`http://localhost:8080/api/v1/adminRoute/singleRoute/${id}`, {
              headers: {
                'Authorization': `Bearer ${token}`
              }
            });
            const data = await response.json();
            if (data && data.id) {
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

      const [formData, setFormData] = useState({
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
          setFormData({
            routeDistance: item.routeDistance|| '',
            routeSource: item.routeSource|| '',
            routeNo: item.routeNo || '',
            distance: item.distance || '',
            perDayCharge: item.perDayCharge || '',
          });
          setUserData({
            routeDistance: item.routeDistance|| '',
            routeSource: item.routeSource|| '',
            routeNo: item.routeNo || '',
            distance: parseInt(item.distance, 10) || '',
            perDayCharge: item.perDayCharge || '',
          });
        }
      }, [item]);

    const handleInputChange = (e) => {
      setFormData({ ...formData, [e.target.name]: e.target.value });
    
    };
  
    const handleSubmit = async (e) => {
      e.preventDefault();
  
      const data = new FormData();
      data.append('busRoute', JSON.stringify(formData));

  
      try {
        const response = await axios.put(`http://localhost:8080/api/v1/adminRoute/update/${id}`, formData, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
  
        if (response.status === 200) {
          alert("Route saved successfully")
          console.log('Route saved successfully');
          navigate('/routePage');
          window.location.reload();
        }
         else {
          const error = await response.text();
          setErrorMessage(`Error saving user: ${error}`);
          alert(errorMessage)
          navigate('/routePage');
          window.location.reload();
        }
      } catch (error) {
        if(error.response.status == 400 ){
            alert("Distance and source, Both are same. OR Route already has been saved")
        }else{
                  console.error('Error:', error);
        setErrorMessage();
        alert('Error saving user.')
        navigate('/routePage');
        window.location.reload();  
        }

      }
    };
  
    
    const validateTelephone = () => {
      const telephoneRegex = /^0\d{9}$/;
      if (!telephoneRegex.test(formData.telephone)) {
        setTelephoneError('Telephone should be 10 digits and start with 0.');
        return false;
      } else {
        setTelephoneError('');
        return true;
      }
    };
    
  const textStyle = {
    fontWeight: 'bold',
    userSelect: 'none',
  };
    return (
    <>
     <cenetr><div className='container my-4'><NavBar /></div></cenetr>
     <div className='container my-4 fs-1' style={textStyle}>
        <center>Route Number: {item && item.id ? item.id.toString() : 'Null'}</center>
      </div>
      <form onSubmit={handleSubmit} className='container my-4 fs-5 text-left'>
        
        <div className='row my-4 '>
        <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Route Source: Default " {userData.routeSource} "</label>
            <input type="text" name="routeSource" onChange={handleInputChange} value={formData.routeSource} className='form-control' required />
          </div>
          <div className='col-lg-5 col-md-12 mx-4 '>
            <label className='mb-1'>Route Distance: Default " {userData.routeDistance} "</label>
            <input type="text" name="routeDistance" onChange={handleInputChange} className='form-control' required value={formData.routeDistance} />
          </div>

        </div>
        <div className='row my-4'>
        <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Route No:  Default " {userData.routeNo} " </label>
            <input type="text" name="routeNo" onChange={handleInputChange} value={formData.routeNo} className='form-control' required />
        </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Distance ( KM ):  Default " {userData.distance} " </label>
            <input type="number" name="distance" onChange={handleInputChange} value={parseInt(formData.distance, 10)} className='form-control' required />
          </div>
        </div>        
        <div className='row my-4'>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Per Day Charge:  Default " {userData.perDayCharge} "</label>
            <input type="number" name="perDayCharge" onChange={handleInputChange} className='form-control' value={formData.perDayCharge} required/>
          </div>
        </div>
                    <br/>
        <div className='row my-2 ' >
            <button type="submit" className='btn btn-warning font-weight-bold fs-5'><b>Submit</b></button>
        </div>
      </form>
      </>
    );
}

export default RouteEdit