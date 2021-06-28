import React, { Component } from 'react';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent'; 
import DialogContentText from '@material-ui/core/DialogContentText'; 

export default class extends Component{    


    /*
    *
    *  isOpenAlert 開啟pop的狀態 : bool
    *  handleAlertClose 關閉狀態 : function
    *  errorMessage 要顯示的 Error 訊息 : String
    * 
    */ 

    render() {
        const {isOpenAlert, handleAlertClose, errorMessage } = this.props;
        return (
            <Dialog
              open={isOpenAlert}
              onClose={handleAlertClose}
              aria-labelledby="alert-dialog-title"
              aria-describedby="alert-dialog-description"
            >
              <DialogContent>
                <DialogContentText id="alert-dialog-description">
                  {errorMessage}
                </DialogContentText>
              </DialogContent>
              <DialogActions>
                <Button onClick={handleAlertClose} color="primary" autoFocus>
                  OK
                </Button>
              </DialogActions>
            </Dialog>
        )	
    }
}