#[derive(Debug, Clone)]
pub enum CipherErr {
    CipherErr(ErrorStack),
    DecodeError(DecodeError),
}

impl Error for CipherErr {
    fn cause(&self) -> Option<&dyn Error> {
        match *self {
            CipherErr::CipherErr(ref cause) => Some(cause),
            CipherErr::DecodeError(ref cause) => Some(cause),
        }
    }
}
impl fmt::Display for CipherErr {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CipherErr::CipherErr(ref err) => write!(f, "cipher error: {}", err),
            CipherErr::DecodeError(ref err) => write!(f, "decode error: {}", err),
        }
    }
}
