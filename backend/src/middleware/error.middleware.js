const errorHandler = (err, req, res, next) => {
  console.error('Error:', err);

  // Default error
  let error = {
    success: false,
    message: 'Internal server error',
    statusCode: 500
  };

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    error.message = 'Validation Error';
    error.statusCode = 400;
    error.errors = Object.values(err.errors).map(val => val.message);
  }

  // JWT errors
  if (err.name === 'JsonWebTokenError') {
    error.message = 'Invalid token';
    error.statusCode = 401;
  }

  if (err.name === 'TokenExpiredError') {
    error.message = 'Token expired';
    error.statusCode = 401;
  }

  // Database errors
  if (err.code === '23505') { // Unique constraint violation
    error.message = 'Resource already exists';
    error.statusCode = 409;
  }

  if (err.code === '23503') { // Foreign key constraint violation
    error.message = 'Referenced resource not found';
    error.statusCode = 400;
  }

  if (err.code === '23502') { // Not null constraint violation
    error.message = 'Required field missing';
    error.statusCode = 400;
  }

  // Custom error with status code
  if (err.statusCode) {
    error.statusCode = err.statusCode;
    error.message = err.message;
  }

  // Don't leak error details in production
  if (process.env.NODE_ENV === 'production' && error.statusCode === 500) {
    error.message = 'Something went wrong';
  }

  res.status(error.statusCode).json({
    success: error.success,
    message: error.message,
    ...(error.errors && { errors: error.errors }),
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

module.exports = errorHandler;
