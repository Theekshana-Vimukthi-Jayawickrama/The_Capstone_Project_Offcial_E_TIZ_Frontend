import React, { useEffect, useState } from 'react'
import axios from 'axios';
import { useLocation } from 'react-router-dom';
import { useNavigate } from 'react-router-dom';
import NavBar from './NavBar';

const EditConductorPage = () => {

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
            const response = await fetch(`http://localhost:8080/api/v1/admin/getConductorAllDetails/${id}`, {
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
            fullName: item.fullName|| '',
            intName: item.intName|| '',
            telephoneNumber: item.telephoneNumber || '',
            dob: item.dob || '',
            address: item.address || '',
            gender: item.gender || '',
            role: item.role  || '',
            residence: item.residence || '',
            photo: null,
          });
          setUserData({
            fullName: item.fullName|| '',
            intName: item.intName|| '',
            telephoneNumber: item.telephoneNumber || '',
            dob: item.dob || '',
            address: item.address || '',
            gender: item.gender || '',
            role: item.role  || '',
            residence: item.residence || '',
            photo: null,
          });
        }
      }, [item]);

    const handleInputChange = (e) => {
      setFormData({ ...formData, [e.target.name]: e.target.value });
    
    };
    const handleFileChange = (e) => {
        const allowedTypes = ['image/jpeg', 'image/png'];
      
        if (e.target.files.length > 0) {
          const file = e.target.files[0];
      
          // Validate file type
          if (allowedTypes.includes(file.type)) {
            setFormData({ ...formData, [e.target.name]: file });
      
            // Read the image and set the preview
            const reader = new FileReader();
      
            reader.onload = (event) => {
              const imagePreview = event.target.result;
              setFormData((prevData) => ({ ...prevData, [`${e.target.name}Preview`]: imagePreview }));
            };
      
            reader.readAsDataURL(file);
          } else {
            alert('Invalid file type. Please upload a JPEG or PNG image.');
          }
        } else {
          // Clear the file and the preview if the user deselects the file
          setFormData((prevData) => ({ ...prevData, [e.target.name]: null, [`${e.target.name}Preview`]: null }));
        }
      };
      
  
    const handleSubmit = async (e) => {
      e.preventDefault();
  
      const data = new FormData();
      data.append('request', JSON.stringify(formData));
      data.append('photo', formData.photo);

  
      try {
        const response = await fetch(`http://localhost:8080/api/v1/admin/updateConductorDetails/${id}`, {
          method: 'PUT',
          body: data,
          headers: {
            'Authorization': `Bearer ${token}`,
          },
        });
  
        if (response.ok) {
          alert('User saved successfully')
          console.log('User saved successfully');
          navigate('/conductorPage');
          window.location.reload();
        } else {
          const error = await response.text();
          setErrorMessage(`Error saving user: ${error}`);
          alert(errorMessage)
          navigate('/conductorPage');
          window.location.reload();
        }
      } catch (error) {
        console.error('Error:', error);
        setErrorMessage('Error saving user.');
        alert(errorMessage)
        navigate('/conductorPage');
        window.location.reload();
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
        <center>Conductor ID: {item && item.conductorId ? item.conductorId.toString() : 'Null'}</center>
      </div>
      <form onSubmit={handleSubmit} className='container my-4 fs-5 text-left'>

      <div className='container border border-danger rounded m-4'>
            <div className='row'>
                <div className='row'>
                    <div className='fs-1 text-center text-danger'>
                        Warnning
                    </div>
                    <div className='fs-4 m-3 text-center'>
                        If no photo is selected as well as not change details, the previous photo and details will be set as the default.
                    </div>
                </div>

            </div>
        </div>

              <div className='row'>
                  <div className='col-lg-12 m-4'>
                    <center><div className='fs-5'>Conductor Photo </div></center>
                    <center>{
                        item && item.photoType &&
                        <img
                          className="no-border img-fluid img-thumbnail bg-image hover-zoom"
                          src={`data:${item.photoType};base64,${item.data}`}
                          style={{ width: '200px', maxHeight: '200px' }}
                          alt={item.photoType}
                        />
                      }</center>

                </div>
              </div>
        
        <div className='row my-4 '>
          
          <div className='col-lg-5 col-md-12 mx-4 '>
            <label className='mb-1'>Full Name: Default " {userData.fullName} "</label>
            <input type="text" name="fullName" onChange={handleInputChange} className='form-control' required value={formData.fullName} />
          </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Initial with Name: Default " {userData.intName} "</label>
            <input type="text" name="intName" onChange={handleInputChange} value={formData.intName} className='form-control' required />
          </div>
        </div>
        <div className='row my-4'>
        <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Role:  Default " {userData.role} " </label>
            <input type="text" name="role" onChange={handleInputChange} value={formData.role} className='form-control' required disabled/>
        </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Residence:  Default " {userData.residence} " </label>
            <input type="text" name="residence" onChange={handleInputChange} value={formData.residence} className='form-control' required />
          </div>
        </div>        
        <div className='row my-4'>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Date of Birth:  Default " {userData.dob} "</label>
            <input type="text" name="dob" onChange={handleInputChange} className='form-control' value={formData.dob} required/>
          </div>
          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Address:  Default " {userData.address} "</label>
            <input  type="text" name="address" onChange={handleInputChange} className='form-control' value={formData.address} required />         
          </div>
        </div>
        
        <div className='row my-4'>
              <div className='col-lg-5 col-md-12 mx-4'>
                <label className='mb-1'>Gender: Default " {userData.gender.toUpperCase()} "</label>
                <select value={formData.gender} name="gender" onChange={handleInputChange} className='form-control' required>
                  <option value="" disabled>Select Gender</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                </select>
              </div>

          <div className='col-lg-5 col-md-12 mx-4'>
            <label className='mb-1'>Telephone Number:  Default " {userData.telephoneNumber} "</label>
            <input name="telephoneNumber" onChange={handleInputChange} className='form-control' required value={formData.telephoneNumber}  onBlur={validateTelephone} placeholder="07xxxxxxxx" ></input>
            <div style={{ color: 'red' }}>{telephoneError}</div>
          </div>
        </div>

        <div className='row my-4 '>
            <div className='col-lg-12 col-md-12 my-4'>
            <center><label className='my-3'>Conductor Photo (JPEG/PNG only):</label></center>
            <center><input type="file" name="photo" accept=".jpeg, .jpg, .png" onChange={handleFileChange} /></center>
            <center>{formData.photo && (
                <img src={formData.photoPreview} alt="Preview" style={{ width: '200px', maxHeight: '200px' }}  className='mt-3'required />
            )}</center>
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

export default EditConductorPage