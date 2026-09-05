graph TD
%% بداية التطبيق
Start((بداية التطبيق)) --> Splash[شاشة البداية / Splash Screen]

    %% التحقق من حالة المستخدم
    Splash --> CheckAuth{هل المستخدم\nمسجل دخول؟}

    %% مسار المستخدم غير المسجل (Guest/Unauthenticated)
    CheckAuth -- "لا" --> LoginOpt{هل يريد\nالتسجيل/الدخول؟}
    LoginOpt -- "نعم" --> Login[شاشة تسجيل الدخول/الإنشاء]
    Login -- "نجاح الدخول" --> SetAuth[حفظ حالة المصادقة في الـ LocalStorage]
    SetAuth --> NavigateHomeAfterLogin[توجيه إلى الصفحة الرئيسية]
    LoginOpt -- "لا/تخطي" --> NavigateHomeAsGuest[توجيه إلى الصفحة الرئيسية كزائر]

    %% مسار المستخدم المسجل (Authenticated)
    CheckAuth -- "نعم" --> NavigateHomeAfterLogin

    %% الصفحة الرئيسية (Home Screen)
    NavigateHomeAfterLogin --> HomeScreen[الصفحة الرئيسية / Home]
    NavigateHomeAsGuest --> HomeScreen

    %% من الرئيسية - التفرع للمميزات الأخرى
    HomeScreen --> ViewProduct[عرض تفاصيل المنتج / Product Details]
    HomeScreen --> ViewCartFromHome[الانتقال للسلة / View Cart]
    HomeScreen --> OpenProfileFromHome[فتح الملف الشخصي / Profile]

    %% من شاشة تفاصيل المنتج
    ViewProduct --> AddToCart[إضافة المنتج للسلة / Add to Cart]
    AddToCart --> HomeScreen

    %% من شاشة السلة (Cart Screen)
    ViewCartFromHome --> CartScreen[شاشة السلة / Cart]
    CartScreen -- "تحديث الكمية/حذف" --> CartScreen
    CartScreen -- "متابعة الشراء" --> Checkout{هل هناك\nطريقة دفع؟}
    Checkout -- "نعم" --> OrderPlaced[إتمام الطلب / Order Success]
    OrderPlaced --> HomeScreen
    Checkout -- "لا" --> AddPayment[إضافة طريقة دفع / Add Payment]
    AddPayment --> Checkout

    %% الملف الشخصي (Profile Screen)
    OpenProfileFromHome --> ProfileScreen[شاشة الملف الشخصي]
    ProfileScreen -- "تعديل البيانات" --> ProfileScreen
    ProfileScreen -- "سجل الطلبات" --> OrdersHistory[سجل الطلبات السابقة]
    ProfileScreen -- "تسجيل الخروج" --> Logout[تسجيل الخروج وحذف الحالة]
    Logout --> CheckAuth

    %% نهاية التدفقات
    OrderPlaced --> End((نهاية عملية الشراء))

---
