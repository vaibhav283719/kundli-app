package com.vaibhav.kundli.ui.premium

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.vaibhav.kundli.databinding.FragmentPremiumBinding
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class PremiumFragment : Fragment() {

    private var _binding: FragmentPremiumBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentPremiumBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.btnMonthly.setOnClickListener {
            showToast("Monthly plan selected - ₹99/month")
            // In production: launch billing flow here
        }

        binding.btnYearly.setOnClickListener {
            showToast("Yearly plan selected - ₹799/year")
            // In production: launch billing flow here
        }

        binding.btnRestorePurchase.setOnClickListener {
            showToast("Restoring purchases...")
            // In production: query existing purchases
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
