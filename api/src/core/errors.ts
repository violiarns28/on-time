export abstract class BaseError extends Error {
  public abstract status: number;
  public abstract type: string;
  constructor(message: string) {
    super(message);
    this.name = this.constructor.name;
    // Ensure the correct prototype chain
    Object.setPrototypeOf(this, new.target.prototype);
  }
  toJSON() {
    return {
      message: this.message,
      status: this.status,
      type: this.type,
      name: this.name,
    };
  }
}

export class AuthenticationError extends BaseError {
  public status = 401;
  public type = 'authentication';
  constructor(public message: string) {
    super(message);
  }
}

export class AuthorizationError extends BaseError {
  public status = 403;
  public type = 'authorization';
  constructor(public message: string) {
    super(message);
  }
}

export class BadRequestError extends BaseError {
  public status = 400;
  public type = 'bad_request';
  constructor(public message: string) {
    super(message);
  }
}
export class NotFoundError extends BaseError {
  public status = 404;
  public type = 'not_found';
  constructor(public message: string) {
    super(message);
  }
}
export class ConflictError extends BaseError {
  public status = 409;
  public type = 'conflict';
  constructor(public message: string) {
    super(message);
  }
}

export class StorageError extends BaseError {
  public status = 500;
  public type = 'storage';
  constructor(public message: string) {
    super(message);
  }
}

export class ServerError extends BaseError {
  public status = 500;
  public type = 'internal';
  constructor(public message: string) {
    super(message);
  }
}

export class UnsupportedMediaTypeError extends BaseError {
  public status = 415;
  public type = 'unsupported_media_type';
  constructor(public message: string) {
    super(message);
  }
}
