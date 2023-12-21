import { describe, it, vi, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductCatalog from '@/views/ProductCatalog.vue'

vi.mock('@/services/api')

describe('ProductCatalog.vue', () => {
  it('renders products in catalog', async () => {
    const wrapper = mount(ProductCatalog, {
      propsData: {},
      sync: true,
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
