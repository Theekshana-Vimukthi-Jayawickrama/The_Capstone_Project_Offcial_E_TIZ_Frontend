import React from 'react';
import Modal from 'react-modal';

const ImagePreviewModal = ({ isOpen, onClose, imageSrc, altText }) => {
  const modalStyles = {
    content: {
      top: '50%',
      left: '50%',
      right: 'auto',
      bottom: 'auto',
      marginRight: '-50%',
      transform: 'translate(-50%, -50%)',
      backgroundColor: 'transparent',
      border: 'none',
      boxShadow: 'none',
    },
    overlay: {
      backgroundColor: 'rgba(0, 0, 0, 0.7)',
    },
  };

  return (
    <Modal isOpen={isOpen} onRequestClose={onClose} style={modalStyles}>
      <div style={{ position: 'relative', maxHeight: '80vh', overflowY: 'auto' }}>
        <span
          style={{
            position: 'absolute',
            top: '10px',
            right: '10px',
            cursor: 'pointer',
            fontSize: '50px',
            color: 'red',
          }}
          onClick={onClose}
        >
          &times;
        </span>
        <img src={imageSrc} alt={altText} style={{ width: '100%', height: 'auto' }} />
      </div>
    </Modal>
  );
};

export default ImagePreviewModal;
