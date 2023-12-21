export default {
  user() {
    return {
      accountIdentifier: '000000-0000-0000-0000-000000000000',
      homeAccountIdentifier: '',
      username: 'demo@example.net',
      name: 'Demo User',
      idToken: null,
      idTokenClaims: null,
      sid: '',
      displayName: 'Demo User',
      environment: 'Fake',
      localAccountId: ''
    }
  },

  clientId() {
    return null
  },

  acquireToken() {
    return '1234'
  }
}
