import { describe, it, vi, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import router from '@/router'
import { flushPromises } from '@vue/test-utils'

import Cart from '@/views/Cart.vue'

vi.mock('@/services/api')
vi.mock('@/services/auth')

describe('Cart.vue', () => {
  it('renders cart contents', async () => {
    const wrapper = mount(Cart, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
