import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import '../config/app_config.dart';
import 'user_service.dart';

class BillingService {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static const String subscriptionId = 'app_premium_sub'; // ID padrão do produto na Play Store
  
  static Future<void> initialize() async {
    if (kIsWeb) return;
    
    try {
      final bool available = await _iap.isAvailable();
      if (!available) {
        debugPrint('Google Play Billing não está disponível.');
        return;
      }
      
      // Escuta atualizações de faturamento em tempo de execução
      _iap.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        debugPrint('Purchase stream encerrado.');
      }, onError: (Object error) {
        debugPrint('Erro no purchase stream: $error');
      });
      
      // Sincroniza status premium com o servidor
      await syncProfileWithBackend();
    } catch (e) {
      debugPrint('Falha ao inicializar BillingService: $e');
    }
  }

  // Sincroniza o perfil Pro local com a base de dados do Backend
  static Future<void> syncProfileWithBackend() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.backendUrl}/api/v1/users/profile'),
        headers: {
          'X-Device-UUID': UserService.deviceUuid,
          'X-App-Language': AppConfig.activeLanguage.name,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final isPremium = data['is_premium'] as bool? ?? false;
        await UserService.setPremium(isPremium);
        debugPrint('Perfil sincronizado com o backend. Premium: $isPremium');
      }
    } catch (e) {
      debugPrint('Erro ao sincronizar perfil com o backend: $e');
    }
  }

  // Dispara o fluxo de compra
  static Future<void> buySubscription() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      throw Exception('Loja de aplicativos indisponível.');
    }

    final ProductDetailsResponse response = await _iap.queryProductDetails({subscriptionId});
    if (response.notFoundIDs.contains(subscriptionId) || response.productDetails.isEmpty) {
      throw Exception('Assinatura "$subscriptionId" não encontrada na loja.');
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    
    // Inicia fluxo de compra de assinatura (não consumível)
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Escuta retornos da Play Store
  static void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint('Compra pendente...');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('Erro na compra: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          
          // Envia o recibo da transação para validação segura no backend
          final bool valid = await verifyPurchaseOnBackend(purchaseDetails);
          if (valid) {
            await UserService.setPremium(true);
            debugPrint('Premium ativado com sucesso após validação.');
          } else {
            debugPrint('Validação de recibo falhou no servidor.');
          }
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  // Envia token ao backend para validação segura
  static Future<bool> verifyPurchaseOnBackend(PurchaseDetails purchase) async {
    try {
      final token = purchase.verificationData.serverVerificationData;
      final productId = purchase.productID;
      final packageName = 'com.learnlanguages.${AppConfig.activeLanguage.name}';

      final response = await http.post(
        Uri.parse('${AppConfig.backendUrl}/api/v1/billing/verify-purchase'),
        headers: {
          'Content-Type': 'application/json',
          'X-Device-UUID': UserService.deviceUuid,
          'X-App-Language': AppConfig.activeLanguage.name,
        },
        body: jsonEncode({
          'purchase_token': token,
          'product_id': productId,
          'package_name': packageName,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] as bool? ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('Erro de conexão ao verificar compra com backend: $e');
      return false;
    }
  }
}
