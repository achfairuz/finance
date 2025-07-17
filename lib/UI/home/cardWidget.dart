import 'package:finance/UI/components/components.dart';
import 'package:finance/UI/home/formRekening.dart';
import 'package:finance/core/constants/constants.dart';
import 'package:finance/core/models/rekening_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCardRekening extends StatelessWidget {
  final List<RekeningModel> bankData;

  const MyCardRekening({super.key, required this.bankData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: bankData.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == bankData.length) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormRekening(action: 'create'),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(right: 8),
                width: 120,
                height: 108,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.disaturate,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            );
          }
          final bank = bankData[index];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormRekening(
                    action: 'update',
                    id: bank.id,
                    name_bank: bank.name_bank,
                    balance: bank.balance,
                  ),
                )),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              width: 120,
              height: 108,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.disaturate,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/onBoarding/OnBoarding1.png'),
                          ),
                          color: AppColors.grey,
                        ),
                      ),
                      SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          bank.name_bank ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppSizes.fontSmall,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatRupiah.format(bank.balance),
                    style: TextStyle(
                      fontSize: AppSizes.fontSmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
