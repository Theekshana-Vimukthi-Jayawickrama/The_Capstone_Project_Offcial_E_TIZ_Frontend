import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from '../Admin/NavBar';

const DeportEdit = () => {

    const searchParams = new URLSearchParams(useLocation().search);
    const token =  sessionStorage.getItem('token');
    const userId = sessionStorage.getItem('userId')
    const id = searchParams.get('id')
    const [telephoneError, setTelephoneError] = useState(''); 
    const [telephoneError2, setTelephoneError2] = useState('');
    const navigate = useNavigate();
    const [errorMessage, setErrorMessage] = useState(null);

     const [item, setItem] = useState(null);

      useEffect(() => {
        const fetchItem = async () => {
          try {
            const response = await fetch(`http://localhost:8080/api/v1/admin/singleDeport/getDetails/${id}`, {
              headers: {
                'Authorization': `Bearer ${token}`
              }
            });
            const data = await response.json();
            if (data) {
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


      const validateTelephone2 = () => {
        const telephoneRegex = /^0\d{9}$/;
        if (!telephoneRegex.test(formData.phoneNumber2)) {
          setTelephoneError2('Telephone should be 10 digits and start with 0.');
          return false;
        } else {
          setTelephoneError2('');
          return true;
        }
      };

      const [formData, setFormData] = useState({
        depotName: '',
        phoneNumber: '',
        phoneNumber2: '',

      });

      const [userData, setUserData] = useState({
        depotName: '',
        phoneNumber: '',
        phoneNumber2: '',

      });
      
      useEffect(() => {
        if (item) {
          setFormData({
            depotName: item.depotName|| '',
            phoneNumber: item. phoneNumber|| '',
            phoneNumber2: item. phoneNumber2 || '',
          });
          setUserData({
            depotName: item.depotName|| '',
            phoneNumber: item. phoneNumber|| '',
            phoneNumber2: item. phoneNumber2 || '',
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
        const response = await axios.put(`http://localhost:8080/api/v1/admin/update/deport/${id}`, formData, {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          });
  
        if (response.status === 200) {
          alert("Route saved successfully")
          console.log('Route saved successfully');
          navigate('/depotPage');
          window.location.reload();
        }
         else {
          const error = await response.text();
          setErrorMessage(`Error saving user: ${error}`);
          alert(errorMessage)
          navigate('/depotPage');
          window.location.reload();
        }
      } catch (error) {
        if(error.response.status == 400 ){
            alert("Distance and source, Both are same. OR Route already has been saved")
        }else{
                  console.error('Error:', error);
        setErrorMessage();
        alert('Error saving user.')
        navigate('/depotPage');
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
        <div className='col-lg-12 col-md-12 mx-4'>
            <label className='mb-1'>Deport Name: Default " {userData.depotName} "</label>
            <input type="text" name="depotName" onChange={handleInputChange} value={formData.depotName} className='form-control' required />
          </div>

          <div className='row my-4'>
          <div className='col-lg-5 col-md-12 mx-4'>
          <label className='mb-1'>Telephone Number 01:  Default " {userData.phoneNumber} " </label>
              <input name="phoneNumber" onChange={handleInputChange} className='form-control' value={formData.phoneNumber}  onBlur={validateTelephone} placeholder="07xxxxxxxx" required ></input>
              <div className ='fs-6' style={{ color: 'red' }}>{telephoneError2}</div>
            </div>
            <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Telephone Number 02:  Default " {userData.phoneNumber2} " </label>
              <input name="phoneNumber2" onChange={handleInputChange} className='form-control' value={formData.phoneNumber2}  onBlur={validateTelephone2} placeholder="07xxxxxxxx" required ></input>
              <div className ='fs-6' style={{ color: 'red' }}>{telephoneError2}</div>
            </div>
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

export default DeportEdit