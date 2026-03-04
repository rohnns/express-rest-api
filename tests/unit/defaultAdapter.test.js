'use strict';

const { configure, resetConfig } = require('../../src/config');
const ApiController = require('../../src/ApiController');

describe('Default Adapter', () => {
  afterEach(() => {
    resetConfig();
  });

  it('should resolve adapter from config factory + model', () => {
    const mockAdapter = { findMany: jest.fn(), findOne: jest.fn() };
    const factory = jest.fn((model) => mockAdapter);

    configure({ adapter: factory });

    class TestController extends ApiController {
      model = 'userModel';
    }

    const ctrl = new TestController();
    expect(ctrl.adapter).toBe(mockAdapter);
    expect(factory).toHaveBeenCalledWith('userModel');
  });

  it('should cache adapter after first access', () => {
    const factory = jest.fn((model) => ({ model }));
    configure({ adapter: factory });

    class TestController extends ApiController {
      model = 'userModel';
    }

    const ctrl = new TestController();
    ctrl.adapter;
    ctrl.adapter;
    ctrl.adapter;
    expect(factory).toHaveBeenCalledTimes(1);
  });

  it('should prefer explicit adapter over config factory', () => {
    const configAdapter = { source: 'config' };
    const explicitAdapter = { source: 'explicit' };

    configure({ adapter: () => configAdapter });

    class TestController extends ApiController {
      model = 'userModel';
      adapter = explicitAdapter;
    }

    const ctrl = new TestController();
    expect(ctrl.adapter).toBe(explicitAdapter);
  });

  it('should return null when no adapter and no model', () => {
    class TestController extends ApiController {}

    const ctrl = new TestController();
    expect(ctrl.adapter).toBeNull();
  });

  it('should return null when model set but no config adapter', () => {
    class TestController extends ApiController {
      model = 'userModel';
    }

    const ctrl = new TestController();
    expect(ctrl.adapter).toBeNull();
  });

  it('should work with explicit adapter without config', () => {
    const explicitAdapter = { findMany: jest.fn() };

    class TestController extends ApiController {
      adapter = explicitAdapter;
    }

    const ctrl = new TestController();
    expect(ctrl.adapter).toBe(explicitAdapter);
  });
});
