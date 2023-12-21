import { describe, it, vi, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductSingle from '@/views/ProductSingle.vue'

const productId = 'prd1'
vi.mock('@/services/api')

describe('ProductSingle.vue', () => {
  it('renders product details', async () => {
    router.push('/product/' + productId)
    await router.isReady()

    const wrapper = mount(ProductSingle, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
