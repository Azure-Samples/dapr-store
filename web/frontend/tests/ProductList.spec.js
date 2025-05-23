import { vi, describe, it, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductList from '@/components/ProductList.vue'

vi.mock('@/services/api')

// Load mock data
// eslint-disable-next-line no-undef
const mockJson = require('fs').readFileSync(__dirname + '/../../../data/mock/products.json')
const mockProducts = JSON.parse(mockJson)

describe('ProductList.vue', () => {
  it('renders product list', async () => {
    const wrapper = mount(ProductList, {
      propsData: {
        products: mockProducts
      },
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
