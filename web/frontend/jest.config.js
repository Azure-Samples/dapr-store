module.exports = {
  preset: '@vue/cli-plugin-unit-jest',
  moduleNameMapper: {
    '\\.(css)$': 'identity-obj-proxy'
  },
  setupFiles: ['<rootDir>/tests/unit/setup.js'],
  verbose: true
}