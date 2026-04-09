package com.vaibhav.kundli.ui.premium

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.vaibhav.kundli.databinding.FragmentPremiumBinding
import com.vaibhav.kundli.util.AdManager
import com.vaibhav.kundli.util.showToast
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class PremiumFragment : Fragment() {

    private var _binding: FragmentPremiumBinding? = null
    private val binding get() = _binding!!

    @Inject lateinit var adManager: AdManager

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        _binding = FragmentPremiumBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        adManager.loadRewarded()

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

        binding.btnWatchAd.setOnClickListener {
            if (!adManager.isRewardedAdReady) {
                showToast("Ad is loading, please try again in a moment")
                adManager.loadRewarded()
                return@setOnClickListener
            }
            adManager.showRewarded(
                activity = requireActivity(),
                onRewarded = {
                    showToast("🎉 You unlocked 1 day free premium access!")
                    // In production: grant temporary premium access here
                },
                onDismissed = {}
            )
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
