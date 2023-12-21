import { describe, it, vi, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductOffers from '@/views/ProductOffers.vue'

vi.mock('@/services/api')

describe('ProductOffers.vue', () => {
  it('renders products on offer', async () => {
    const wrapper = mount(ProductOffers, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
