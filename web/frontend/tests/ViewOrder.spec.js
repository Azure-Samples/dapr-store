import { describe, it, vi, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductSearch from '@/views/ViewOrder.vue'

vi.mock('@/services/api')
vi.mock('@/services/auth')

describe('ViewOrder.vue', () => {
  it('shows order details', async () => {
    router.push('/order/ord-mock')
    await router.isReady()

    const wrapper = mount(ProductSearch, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
