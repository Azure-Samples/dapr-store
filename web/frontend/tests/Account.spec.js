import { describe, it, vi, expect } from 'vitest'
import { flushPromises, mount } from '@vue/test-utils'
import router from '@/router'

import Account from '@/views/Account.vue'

vi.mock('@/services/auth')
vi.mock('@/services/api')

describe('Account.vue', () => {
  it('renders user profile', async () => {
    const wrapper = mount(Account, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
