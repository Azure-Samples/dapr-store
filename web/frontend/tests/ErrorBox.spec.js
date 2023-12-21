import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'

import ErrorBox from '@/components/ErrorBox.vue'

describe('ErrorBox.vue', () => {
  it('renders properly', () => {
    const wrapper = mount(ErrorBox, { props: { error: 'Really bad thing just happened' } })
    expect(wrapper.html()).toMatchSnapshot()
  })
})
