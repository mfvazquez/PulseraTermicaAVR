CUENTAS = 99999

def enlapsed (init,end):
    if (init <= end):
        return end-init
    return (end + CUENTAS - init)

print enlapsed(99990,10)
print enlapsed(10,10)
print enlapsed(100,1009)